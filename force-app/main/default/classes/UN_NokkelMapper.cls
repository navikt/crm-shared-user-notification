public with sharing class UN_NokkelMapper {
    public static UN_NokkelLegacy userNotificationToNokkelLegacy(UserNotification__c userNotification) {
        UN_NokkelLegacy nokkel = new UN_NokkelLegacy();

        nokkel.eventId = userNotification.INT_EventId__c;
        nokkel.systembruker = userNotification.INT_SystemUser__c;

        return nokkel;
    }

    public static UserNotification__c nokkelLegacyToUserNotification(UN_NokkelLegacy nokkel) {
        return nokkelLegacyToUserNotification(nokkel, new UserNotification__c());
    }

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
