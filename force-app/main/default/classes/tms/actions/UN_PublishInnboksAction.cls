public without sharing class UN_PublishInnboksAction {
    @InvocableMethod(
        label='Publish Innboks Notifications'
        description='Publish a list of user notifications so that they appear on Nav.no.'
        category='User Notification'
    )
    public static List<UserNotification__c> publishInnboksNotification(List<UserNotification__c> userNotifications) {
        return UN_UserNotificationController.publishInnboksEvents(userNotifications, true);
    }
}
