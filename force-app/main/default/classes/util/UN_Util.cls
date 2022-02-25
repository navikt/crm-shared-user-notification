public with sharing class UN_Util {
    private static Set<String> SF_SYSTEM_USERS = new Set<String>{ 'teamnks' };

    public static String stringToMultiSelect(String str, String delimiter) {
        return String.isBlank(str) ? null : listToMultiSelect(str.split(delimiter));
    }

    public static String listToMultiSelect(List<String> stringList) {
        return stringList != null && stringList.size() > 0 ? String.join(stringList, ';') : null;
    }

    public static List<String> multiSelectToList(String multiSelect) {
        return String.isNotBlank(multiSelect) ? multiSelect.split(';') : new List<String>();
    }

    public static String multiSelectToString(String multiSelect) {
        return String.join(multiSelectToList(multiSelect), ',');
    }

    public static List<UserNotification__c> getUserNotifications(List<UserNotification__c> notifications) {
        return Database.query(getBaseUserNotificationQuery().setCondition('Id IN :notifications').toSOQL());
    }

    public static List<UserNotification__c> getUserNotifications(Set<Id> notificationIds) {
        return Database.query(getBaseUserNotificationQuery().setCondition('Id IN :notificationIds').toSOQL());
    }

    private static fflib_QueryFactory getBaseUserNotificationQuery() {
        return new fflib_QueryFactory(UserNotification__c.SObjectType)
            .selectField('Id')
            .selectField('INT_GroupingId__c')
            .selectField('INT_SocialSecurityNumber__c')
            .selectField('INT_Link__c')
            .selectField('INT_SecurityLevel__c')
            .selectField('INT_Description__c')
            .selectField('INT_EventTime__c')
            .selectField('INT_Type__c')
            .selectField('INT_PreferredChannel__c')
            .selectField('INT_ExternalNotification__c')
            .selectField('INT_EventId__c')
            .selectField('INT_SystemUser__c')
            .selectField('CRM_Account__c')
            .selectField('CRM_RelatedSfRecord__c')
            .selectField('CRM_Done__c')
            .selectField('CRM_NotificationError__c')
            .selectField('INT_Key__c')
            .selectField('INT_DoneEventTime__c');
    }
}
