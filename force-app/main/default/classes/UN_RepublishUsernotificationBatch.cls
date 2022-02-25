public without sharing class UN_RepublishUsernotificationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    public String filter = 'CreatedDate = TODAY  AND INT_Type__c =\'INNBOKS\' AND INT_ExternalNotification__c = false AND CRM_NotificationError__c != null';
    public Boolean isDoneNotifications = false;
    public Integer batchSize = 50;

    public UN_RepublishUsernotificationBatch setFilter(String filter) {
        this.filter = filter;
        return this;
    }

    public UN_RepublishUsernotificationBatch setIsDoneNotifications() {
        this.isDoneNotifications = true;
        return this;
    }

    public UN_RepublishUsernotificationBatch setBatchSize(Integer batchSize) {
        this.batchSize = batchSize;
        return this;
    }

    public void run() {
        Database.executeBatch(this, this.batchSize);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            new fflib_QueryFactory(UserNotification__c.SObjectType).selectField('Id').setCondition(this.filter).toSOQL()
        );
    }

    public void execute(Database.BatchableContext BC, List<UserNotification__c> scope) {
        List<UN_EventProducer> producerList = new List<UN_EventProducer>();
        fflib_QueryFactory qf = new fflib_QueryFactory(UserNotification__c.SObjectType)
            .selectFields(new List<Schema.SObjectField>{ UserNotification__c.Id, UserNotification__c.CRM_Done__c })
            .setCondition('Id IN :scope');

        for (UserNotification__c un : UN_Util.getUserNotifications(scope)) {
            if (true == isDoneNotifications && true == un.CRM_Done__c) {
                producerList.add(UN_EventProducer.getEventProducer(un, true).setError('').setSystemContext());
            } else if (false == isDoneNotifications) {
                if (true == un.CRM_Done__c) {
                    un.INT_ExternalNotification__c = false;
                    un.INT_PreferredChannel__c = '';
                    producerList.add(UN_EventProducer.getEventProducer(un, false).setSystemContext());
                } else {
                    producerList.add(UN_EventProducer.getEventProducer(un, false).setError('').setSystemContext());
                }
            }
        }

        if (producerList.size() > 0) {
            UN_EventProducer.publish(producerList);
        }
    }

    public void finish(Database.BatchableContext BC) {
    }
}
