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

    public static UserNotification__c nokkelInputToUserNotification(
        UN_NokkelInput nokkel,
        UserNotification__c userNotification
    ) {
        userNotification.INT_EventId__c = nokkel.eventId;
        userNotification.INT_GroupingId__c = nokkel.grupperingsId;
        userNotification.INT_SocialSecurityNumber__c = nokkel.fodselsnummer;
        userNotification.INT_AppName__c = nokkel.appnavn;
        userNotification.INT_Namespace__c = nokkel.namespace;
        userNotification.INT_Key__c = nokkel.appnavn + nokkel.namespace + nokkel.eventId;
        return userNotification;
    }

    public static UN_NokkelInput userNotificationToNokkelInput(UserNotification__c userNotification) {
        return new UN_NokkelInputBuilder()
            .withEventId(userNotification.INT_EventId__c)
            .withGrupperingsId(userNotification.INT_GroupingId__c)
            .withFodselsnummer(userNotification.INT_SocialSecurityNumber__c)
            .withNamespace(userNotification.INT_Namespace__c)
            .withAppnavn(userNotification.INT_AppName__c)
            .build();
    }
}
