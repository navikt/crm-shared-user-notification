public with sharing class UserNotification_SetValuesOnBefore extends MyTriggers {
    Map<Id, Person__c> personMap;

    public override void onBeforeInsert() {
        List<UserNotification__c> notifications = new List<UserNotification__c>();
        Set<Id> accountIds = new Set<Id>();

        for (UserNotification__c notification : (List<UserNotification__c>) records) {
            if (UserNotification_Util.isUnpublishedMessage(notification)) {
                notifications.add(notification);
                if (String.isBlank(notification.INT_SocialSecurityNumber__c)) {
                    accountIds.add(notification.CRM_Account__c);
                }
            }
        }

        if (notifications.size() > 0) {
            getPersons(accountIds);
            setValues(notifications);
        }
    }

    public void setValues(List<UserNotification__c> notifications) {
        for (UserNotification__c notification : (List<UserNotification__c>) records) {
            try {
                if (String.isBlank(notification.INT_SocialSecurityNumber__c)) {
                    setFoedselsnummer(notification);
                }
            } catch (Exception e) {
                notification.addError(UserNotification_Util.createErrorMessage(e));
            }
        }
    }

    private void setFoedselsnummer(UserNotification__c notification) {
        notification.INT_SocialSecurityNumber__c = personMap.get(notification.CRM_Account__c).Name;
    }

    private void getPersons(Set<Id> accountIds) {
        personMap = new Map<Id, Person__c>();

        if (accountIds.size() > 0) {
            for (Person__c person : [
                SELECT Id, Name, CRM_Account__c
                FROM Person__c
                WHERE CRM_Account__c IN :accountIds
            ]) {
                personMap.put(person.CRM_Account__c, person);
            }
        }
    }
}
