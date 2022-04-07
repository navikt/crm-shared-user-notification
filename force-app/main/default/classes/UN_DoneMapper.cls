public with sharing class UN_DoneMapper {
    // public static UserNotification__c doneLegacyToUserNotification(
    //     UN_DoneLegacy done,
    //     UserNotification__c userNotification
    // ) {
    //     userNotification.INT_SocialSecurityNumber__c = done.fodselsnummer;
    //     userNotification.INT_GroupingId__c = done.grupperingsId;
    //     userNotification.INT_DoneEventTime__c = done.tidspunkt;
    //     userNotification.CRM_Done__c = true;
    //     return userNotification;
    // }

    public static UserNotification__c doneInputToUserNotification(
        UN_DoneInput done,
        UserNotification__c userNotification
    ) {
        userNotification.INT_DoneEventTime__c = DateTime.newInstance(done.tidspunkt);
        userNotification.CRM_Done__c = true;
        return userNotification;
    }

    public static UN_DoneInput userNotificationToDoneInput(UserNotification__c userNotification) {
        return new UN_DoneInputBuilder().withTidspunkt(userNotification.INT_DoneEventTime__c).build();
    }
}
