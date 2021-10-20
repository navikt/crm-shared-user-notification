public with sharing class UN_BrukernotifikasjonCalloutService {
    private final static string API_CONFIG_NAME = 'BRUKERNOTIFIKASJONER'; //API Config name to set when using the ApiController
    private final static string SERVICE_AUTH_HEADER = 'Brukernotifikasjon';

    public static HttpResponse postInnboksNotificationLegacy(UN_InnboksLegacy innboksEvent, UN_NokkelLegacy nokkel) {
        return postInnboksNotificationLegacy(innboksEvent, nokkel, false);
    }

    public static HttpResponse postInnboksNotificationLegacy(
        UN_InnboksLegacy innboksEvent,
        UN_NokkelLegacy nokkel,
        Boolean isSystemContext
    ) {
        ApiController apiCtrl = new ApiController();
        if (isSystemContext == true) {
            apiCtrl.setSystemContext();
        }
        apiCtrl.initRequest(API_CONFIG_NAME, 'POST_INNBOKS_EVENT');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.addUrlParam('eventId', nokkel.eventId);
        apiCtrl.setBody(JSON.serialize(innboksEvent));
        apiCtrl.doCallout();

        return apiCtrl.getResponse();
    }

    public static HttpResponse postDoneNotificationLegacy(UN_DoneLegacy doneEvent, UN_NokkelLegacy nokkel) {
        return postDoneNotificationLegacy(doneEvent, nokkel, false);
    }

    public static HttpResponse postDoneNotificationLegacy(
        UN_DoneLegacy doneEvent,
        UN_NokkelLegacy nokkel,
        Boolean isSystemContext
    ) {
        ApiController apiCtrl = new ApiController();
        if (isSystemContext == true) {
            apiCtrl.setSystemContext();
        }
        apiCtrl.initRequest(API_CONFIG_NAME, 'POST_DONE_EVENT');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.addUrlParam('eventId', nokkel.eventId);
        apiCtrl.setBody(JSON.serialize(doneEvent));
        apiCtrl.doCallout();

        return apiCtrl.getResponse();
    }
}
