public inherited sharing class UN_PublishDoneNotificationAction {
    @InvocableMethod(
        label='Publish Done Notification'
        description='Send done notifications for a list of user notifications. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> publishDoneNotification(List<UserNotification__c> userNotifications) {
        return UN_UserNotifications.publishDoneEvent(userNotifications, true);
    }
}
