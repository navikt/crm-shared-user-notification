public without sharing class UN_PublishInaktiverAction {
    @InvocableMethod(
        label='Publish Inaktiver Events'
        description='Sends Inaktiver events for a list of user notifications. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> publishInaktiverNotification(List<UserNotification__c> userNotifications) {
        return UN_UserNotificationController.publishInaktiverEvents(userNotifications, true);
    }
}
