public inherited sharing class UN_UserNotificationController {
    private static LoggerUtility logger = new LoggerUtility('User Notification');

    private static String postInnboksEvent(UN_InnboksEvent innboksEvent, Boolean isSystemContext) {
        innboksEvent.validate();
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(innboksEvent, isSystemContext);
        if (resp == null || resp.getStatusCode() != 200) {
            String logUuid = null;
            logger.httpError('Could not publish user notifications', resp, null, null);
            logUuid = logger.peek().UUID__c;
            logger.publish();
            throw new UN_UserNotificationsException('Could not publish user notifications. Log uuid: ' + logUuid);
        }
        return resp.getBody();
    }

    public static List<UserNotification__c> publishInnboksEvents(
        List<UserNotification__c> userNotifications,
        Boolean isSystemContext
    ) {
        List<UserNotification__c> toUpsert = new List<UserNotification__c>();

        for (UserNotification__c un : userNotifications) {
            if (un.CRM_SuccessfullySentNotification__c == true)
                continue;
            try {
                un.INT_Namespace__c = UN_Produsent.DEFAULT_NAMESPACE;
                un.INT_AppName__c = UN_Produsent.DEFAULT_APPNAVN;
                UN_InnboksEvent innboksEvent = UN_InnboksMapper.createInnboksEventFromUserNotification(un);
                postInnboksEvent(innboksEvent, isSystemContext);
                un.CRM_SuccessfullySentNotification__c = true;
                un.CRM_NotificationError__c = null;
            } catch (Exception e) {
                un.CRM_SuccessfullySentNotification__c = false;
                un.CRM_NotificationError__c = e.getMessage();
                logger.exception(e);
                logger.publish();
            }
            toUpsert.add(un);
        }
        try {
            upsert toUpsert;
        } catch (Exception e) {
            logger.exception(e);
            logger.publish();
            for (UserNotification__c un : toUpsert) {
                un.CRM_SuccessfullySentNotification__c = false;
                un.CRM_NotificationError__c = '[upsert-failed]: ' + e.getMessage();
            }
        }
        return toUpsert;
    }

    public class UN_UserNotificationsException extends Exception {
    }
}
