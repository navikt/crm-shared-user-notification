public with sharing class UN_BrukernotifikasjonCalloutService {
    private final static string API_CONFIG_NAME = 'UN_SF_BRUKERNOTIFIKASJONER'; //API Config name to set when using the ApiController
    private final static string SERVICE_AUTH_HEADER = 'sfBrukernotifikasjon';

    public static HttpResponse postInnboksNotification(List<UN_InnboksEvent> innboksEvents, Boolean isSystemContext) {
        ApiController apiCtrl = new ApiController();
        if (isSystemContext == true) {
            apiCtrl.setSystemContext();
        }
        apiCtrl.initRequest(API_CONFIG_NAME, 'UN_POST_INNBOKS_EVENTS');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.setBody(JSON.serialize(innboksEvents));
        apiCtrl.doCallout();

        return apiCtrl.getResponse();
    }

    public static HttpResponse postDoneNotification(List<UN_DoneEvent> doneEvents, Boolean isSystemContext) {
        ApiController apiCtrl = new ApiController();
        if (isSystemContext == true) {
            apiCtrl.setSystemContext();
        }
        apiCtrl.initRequest(API_CONFIG_NAME, 'UN_POST_DONE_EVENTS');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.setBody(JSON.serialize(doneEvents));
        apiCtrl.doCallout();

        return apiCtrl.getResponse();
    }
}
