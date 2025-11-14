public without sharing class UN_PublishInnboksNotificationAction {
    @InvocableMethod(
        label='Publish Innboks Notification'
        description='Publish a list of user notifications so that they that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> publishInnboksNotification(List<UserNotification__c> userNotifications) {
        return UN_UserNotificationController.publishInnboksEvents(userNotifications, true);
    }
}
