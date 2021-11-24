public with sharing class UN_DoneMapper {
    public static UserNotification__c doneLegacyToUserNotification(
        UN_DoneLegacy done,
        UserNotification__c userNotification
    ) {
        userNotification.INT_SocialSecurityNumber__c = done.fodselsnummer;
        userNotification.INT_GroupingId__c = done.grupperingsId;
        userNotification.INT_DoneEventTime__c = done.tidspunkt;
        userNotification.CRM_Done__c = true;
        return userNotification;
    }

    public static UN_DoneLegacy userNotificationToDoneLegacy(UserNotification__c userNotification) {
        return new UN_DoneBuilderLegacy()
            .withTidspunkt(userNotification.INT_DoneEventTime__c)
            .withGrupperingsId(userNotification.INT_GroupingId__c)
            .withFodselsnummer(userNotification.INT_SocialSecurityNumber__c)
            .build();
    }
}
