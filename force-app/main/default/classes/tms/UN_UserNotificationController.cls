public inherited sharing class UN_UserNotificationController {
    private static LoggerUtility logger = new LoggerUtility('User Notification');

    public static String publishInnboksEvent(List<UN_InnboksEvent> innboksEvents, Boolean isSystemContext) {
        List<UN_OpprettVarselEvent> opprettVarselEvents = new List<UN_OpprettVarselEvent>();
        for (UN_InnboksEvent e : innboksEvents) {
            opprettVarselEvents.add(e);
        }
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(opprettVarselEvents, isSystemContext);
        if (resp.getStatusCode() != 200) {
            String logUuid;
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
        List<UN_InnboksEvent> innboksEvents = new List<UN_InnboksEvent>();
        for (UserNotification__c un : userNotifications) {
            if (un.CRM_SuccessfullySentNotification__c == true) {
                continue;
            }
            un.INT_Namespace__c = 'teamnks';
            un.INT_AppName__c = 'sf-brukernotifikasjon';
            un.CRM_SuccessfullySentNotification__c = true;

            try {
                innboksEvents.add(new UN_InnboksEvent(un));
            } catch (Exception e) {
                un.CRM_SuccessfullySentNotification__c = false;
                un.CRM_NotificationError__c = e.getMessage();
            }
        }

        try {
            publishInnboksEvent(innboksEvents, isSystemContext);
        } catch (Exception e) {
            for (UserNotification__c un : userNotifications) {
                if (un.CRM_SuccessfullySentNotification__c) {
                    un.CRM_SuccessfullySentNotification__c = false;
                    un.CRM_NotificationError__c = e.getMessage();
                }
            }
            logger.exception(e);
            logger.publish();
        }

        try {
            upsert userNotifications;
        } catch (Exception e) {
            logger.exception(e);
            logger.publish();
        }

        return userNotifications;
    }

    public class UN_UserNotificationsException extends Exception {
    }
}
