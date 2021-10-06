public with sharing class UN_UserNotifications {
    public static void publishInboksEvent(UN_InnboksLegacy innboksEvent, UN_NokkelLegacy nokkel) {
        HttpResponse resp = UN_BrukernotifikasjonCalloutService.postInnboksNotificationLegacy(innboksEvent, nokkel);

        if (resp.getStatusCode() != 200) {
            String logUuid;
            LoggerUtility log = new LoggerUtility();
            log.httpError('Could not publish Innboks event', resp, null, null);
            logUuid = log.peek().UUID__c;
            log.publish();
            throw new UN_UserNotificationsException('Could not publish notification. Log uuid: ' + logUuid);
        }
    }

    public static void publishDoneEvent(UN_DoneLegacy doneEvent, UN_NokkelLegacy nokkel) {
        HttpResponse resp = UN_BrukernotifikasjonCalloutService.postDoneNotificationLegacy(doneEvent, nokkel);

        if (resp.getStatusCode() != 200) {
            String logUuid;
            LoggerUtility log = new LoggerUtility();
            log.httpError('Could not publish Innboks event', resp, null, null);
            logUuid = log.peek().UUID__c;
            log.publish();
            throw new UN_UserNotificationsException('Could not publish notification. Log uuid: ' + logUuid);
        }
    }

    public class UN_UserNotificationsException extends Exception {
    }
}
