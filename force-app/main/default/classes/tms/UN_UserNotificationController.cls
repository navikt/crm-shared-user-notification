public inherited sharing class UN_UserNotificationController {
    private static LoggerUtility logger = new LoggerUtility('User Notification');

    private static String postInnboksEvent(UN_InnboksEvent innboksEvent, Boolean isSystemContext) {
        innboksEvent.validate();
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(innboksEvent, isSystemContext);
        if (resp == null || resp.getStatusCode() != 200) {
            String logUuid = null;
            logger.httpError('Could not publish Opprett Varsel events', resp, null, null);
            logUuid = logger.peek().UUID__c;
            logger.publish();
            throw new UN_UserNotificationsException('Could not publish Opprett Varsel events. Log uuid: ' + logUuid);
        }
        return resp.getBody();
    }

    private static String postInaktiverEvent(UN_InaktiverEvent inaktiverEvent, Boolean isSystemContext) {
        inaktiverEvent.validate();
        HttpResponse resp = UN_UserNotificationService.postInaktiverVarselEvent(inaktiverEvent, isSystemContext);
        if (resp == null || resp.getStatusCode() != 200) {
            String logUuid = null;
            logger.httpError('Could not publish Inaktiver Varsel events', resp, null, null);
            logUuid = logger.peek().UUID__c;
            logger.publish();
            throw new UN_UserNotificationsException('Could not publish Inaktiver Varsel events. Log uuid: ' + logUuid);
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
                un.CRM_SuccessfullySentNotification__c = true;
                un.CRM_NotificationError__c = null;
                UN_InnboksEvent innboksEvent = UN_EventMapper.createInnboksEventFromUserNotification(un);
                postInnboksEvent(innboksEvent, isSystemContext);
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

    public static List<UserNotification__c> publishInaktiverEvents(
        List<UserNotification__c> userNotifications,
        Boolean isSystemContext
    ) {
        List<UserNotification__c> toUpdate = new List<UserNotification__c>();

        for (UserNotification__c un : userNotifications) {
            if (un.CRM_SuccessfullySentDone__c == true) {
                continue;
            }
            try {
                un.INT_Namespace__c = UN_Produsent.DEFAULT_NAMESPACE;
                un.INT_AppName__c = UN_Produsent.DEFAULT_APPNAVN;
                un.CRM_SuccessfullySentDone__c = true;
                un.CRM_NotificationError__c = '';
                UN_InaktiverEvent inaktiverEvent = UN_EventMapper.createInaktiverEventFromUserNotification(un);
                postInaktiverEvent(inaktiverEvent, isSystemContext);
            } catch (Exception e) {
                un.CRM_SuccessfullySentDone__c = false;
                un.CRM_NotificationError__c = e.getMessage();
                logger.exception(e);
                logger.publish();
            }
            toUpdate.add(un);
        }
        try {
            update toUpdate;
        } catch (Exception e) {
            logger.exception(e);
            logger.publish();
            for (UserNotification__c un : toUpdate) {
                un.CRM_SuccessfullySentDone__c = false;
                un.CRM_NotificationError__c = '[update-failed]: ' + e.getMessage();
            }
        }
        return toUpdate;
    }

    public class UN_UserNotificationsException extends Exception {
    }
}
