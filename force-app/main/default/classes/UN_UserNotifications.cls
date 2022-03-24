public inherited sharing class UN_UserNotifications {
    public static List<UserNotification__c> publishInboksEvent(
        List<UserNotification__c> innboksNotifications,
        Boolean isSystemContext
    ) {
        List<UN_InnboksEvent> innboksEvents = new List<UN_InnboksEvent>();
        for (UserNotification__c un : innboksNotifications) {
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
            for (UserNotification__c un : innboksNotifications) {
                if (un.CRM_SuccessfullySentNotification__c) {
                    un.CRM_SuccessfullySentNotification__c = false;
                    un.CRM_NotificationError__c = e.getMessage();
                }
            }
        }

        upsert innboksNotifications;

        return innboksNotifications;
    }

    public static String publishInnboksEvent(List<UN_InnboksEvent> innboksEvents, Boolean isSystemContext) {
        HttpResponse resp = UN_BrukernotifikasjonCalloutService.postInnboksNotification(innboksEvents, isSystemContext);

        if (resp.getStatusCode() != 200) {
            String logUuid;
            LoggerUtility log = new LoggerUtility();
            log.httpError('Could not publish Innboks event', resp, null, null);
            logUuid = log.peek().UUID__c;
            log.publish();
            throw new UN_UserNotificationsException('Could not publish innboks event. Log uuid: ' + logUuid);
        }

        return resp.getBody();
    }

    public static List<UserNotification__c> publishDoneEvent(
        List<UserNotification__c> userNotifications,
        Boolean isSystemContext
    ) {
        List<UN_DoneEvent> doneEvents = new List<UN_DoneEvent>();
        for (UserNotification__c done : userNotifications) {
            if (done.CRM_SuccessfullySentDone__c == true) {
                continue;
            }
            done.INT_Namespace__c = 'teamnks';
            done.INT_AppName__c = 'sf-brukernotifikasjon';
            done.CRM_SuccessfullySentDone__c = true;
            done.CRM_NotificationError__c = '';

            try {
                doneEvents.add(new UN_DoneEvent(done));
            } catch (Exception e) {
                done.CRM_SuccessfullySentDone__c = false;
                done.CRM_NotificationError__c = e.getMessage();
            }
        }

        try {
            publishDoneEvent(doneEvents, isSystemContext);
        } catch (Exception e) {
            for (UserNotification__c done : userNotifications) {
                if (done.CRM_SuccessfullySentDone__c) {
                    done.CRM_SuccessfullySentDone__c = false;
                    done.CRM_NotificationError__c = e.getMessage();
                }
            }
        }

        update userNotifications;

        return userNotifications;
    }

    public static String publishDoneEvent(List<UN_DoneEvent> doneEvents, Boolean isSystemContext) {
        HttpResponse resp = UN_BrukernotifikasjonCalloutService.postDoneNotification(doneEvents, isSystemContext);

        if (resp.getStatusCode() != 200) {
            String logUuid;
            LoggerUtility log = new LoggerUtility();
            log.httpError('Could not publish Done event', resp, null, null);
            logUuid = log.peek().UUID__c;
            log.publish();
            throw new UN_UserNotificationsException('Could not publish done event. Log uuid: ' + logUuid);
        }

        return resp.getBody();
    }

    // public static void publishInnboksEvent(UN_InnboksLegacy innboksEvent, UN_NokkelLegacy nokkel) {
    //     publishInnboksEvent(innboksEvent, nokkel, false);
    // }

    // public static void publishInnboksEvent(
    //     UN_InnboksLegacy innboksEvent,
    //     UN_NokkelLegacy nokkel,
    //     Boolean isSystemContext
    // ) {
    //     HttpResponse resp = UN_BrukernotifikasjonCalloutService.postInnboksNotificationLegacy(
    //         innboksEvent,
    //         nokkel,
    //         isSystemContext
    //     );

    //     if (resp.getStatusCode() != 200) {
    //         String logUuid;
    //         LoggerUtility log = new LoggerUtility();
    //         log.httpError('Could not publish Innboks event', resp, null, null);
    //         logUuid = log.peek().UUID__c;
    //         log.publish();
    //         throw new UN_UserNotificationsException('Could not publish notification. Log uuid: ' + logUuid);
    //     }
    // }

    // public static void publishDoneEvent(UN_DoneLegacy doneEvent, UN_NokkelLegacy nokkel) {
    //     publishDoneEvent(doneEvent, nokkel, false);
    // }
    // public static void publishDoneEvent(UN_DoneLegacy doneEvent, UN_NokkelLegacy nokkel, Boolean isSystemContext) {
    //     HttpResponse resp = UN_BrukernotifikasjonCalloutService.postDoneNotificationLegacy(
    //         doneEvent,
    //         nokkel,
    //         isSystemContext
    //     );

    //     if (resp.getStatusCode() != 200) {
    //         String logUuid;
    //         LoggerUtility log = new LoggerUtility();
    //         log.httpError('Could not publish Innboks event', resp, null, null);
    //         logUuid = log.peek().UUID__c;
    //         log.publish();
    //         throw new UN_UserNotificationsException('Could not publish notification. Log uuid: ' + logUuid);
    //     }
    // }

    // public static UserNotification__c rePublishEventLegacy(Id userNotificationId, Boolean isDoneEvent) {
    //     List<UserNotification__c> notifications = rePublishEventsLegacy(new Set<Id>{ userNotificationId }, isDoneEvent);
    //     return notifications == null || notifications.isEmpty() ? null : notifications[0];
    // }

    // public static List<UserNotification__c> rePublishEventsLegacy(Set<Id> userNotificationIdSet, Boolean isDoneEvent) {
    //     List<UN_EventProducer> producerList = new List<UN_EventProducer>();

    //     for (UserNotification__c un : UN_Util.getUserNotifications(userNotificationIdSet)) {
    //         if (String.isBlank(un.CRM_NotificationError__c)) {
    //             continue;
    //         }
    //         producerList.add(UN_EventProducer.getEventProducer(un, isDoneEvent).setError(''));
    //     }

    //     return UN_EventProducer.publish(producerList);
    // }

    public class UN_UserNotificationsException extends Exception {
    }
}
