public inherited sharing class UN_UserNotificationController {
    public static String publishInnboksEvent(List<UN_InnboksEvent> innboksEvents, Boolean isSystemContext) {
        List<UN_OpprettVarselEvent> opprettVarselEvents = new List<UN_OpprettVarselEvent>();
for (UN_InnboksEvent e : innboksEvents) {
    opprettVarselEvents.add(e);
}
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(opprettVarselEvents, isSystemContext);
        if (resp.getStatusCode() != 200) {
            String logUuid;
            LoggerUtility log = new LoggerUtility();
            log.httpError('Could not publish user notifications', resp, null, null);
            logUuid = log.peek().UUID__c;
            log.publish();
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

            if (true == un.CRM_Done__c) {
                un.INT_ExternalNotification__c = false;
                un.INT_PreferredChannel__c = '';
            } else {
                un.CRM_NotificationError__c = '';
            }

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
            LoggerUtility log = new LoggerUtility();
            log.exception(e);
            log.publish();
        }

        try {
            upsert userNotifications;
        } catch (Exception e) {
            LoggerUtility log = new LoggerUtility();
            log.exception(e);
            log.publish();
        }

        return userNotifications;
    }

      public class UN_UserNotificationsException extends Exception {
    }
}
