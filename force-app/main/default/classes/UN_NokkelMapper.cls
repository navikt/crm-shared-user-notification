public with sharing class UN_NokkelMapper {
    public static UserNotification__c nokkelLegacyToUserNotification(
        UN_NokkelLegacy nokkel,
        UserNotification__c userNotification
    ) {
        userNotification.INT_EventId__c = nokkel.eventId;
        userNotification.INT_SystemUser__c = nokkel.systembruker;
        userNotification.INT_Key__c = nokkel.systembruker + nokkel.eventId;

        return userNotification;
    }
}
