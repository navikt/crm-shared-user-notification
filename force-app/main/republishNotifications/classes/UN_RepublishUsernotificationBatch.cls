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

    public Id run() {
        return Database.executeBatch(this, this.batchSize);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            new fflib_QueryFactory(UserNotification__c.SObjectType).selectField('Id').setCondition(this.filter).toSOQL()
        );
    }

    public void execute(Database.BatchableContext BC, List<UserNotification__c> scope) {
        List<UserNotification__c> notificationsToUpdate = UN_Util.getUserNotifications(scope);

        if (isDoneNotifications == true) {
            UN_UserNotificationController.publishInaktiverEvents(notificationsToUpdate, true);
        } else {
            UN_UserNotificationController.publishInnboksEvents(notificationsToUpdate, true);
        }
    }

    public void finish(Database.BatchableContext BC) {
    }
}
