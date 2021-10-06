public with sharing class UN_DoneMapper {
    public static UN_DoneLegacy userNotificationToDoneLegacy(UserNotification__c userNotification) {
        UN_DoneLegacy done = new UN_DoneLegacy();
        done.fodselsnummer = userNotification.INT_SocialSecurityNumber__c;
        done.grupperingsId = userNotification.INT_GroupingId__c;
        done.tidspunkt = userNotification.INT_DoneEventTime__c;

        return done;
    }

    public static UserNotification__c doneLegacyToUserNotification(UN_DoneLegacy done) {
        return doneLegacyToUserNotification(done, new UserNotification__c());
    }

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
}
