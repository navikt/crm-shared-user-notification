public with sharing class UN_UserNotificationService {
      private final static string API_CONFIG_NAME = 'UN_SF_BRUKERNOTIFIKASJONER'; 
    private final static string SERVICE_AUTH_HEADER = 'sfBrukernotifikasjon';

    public static HttpResponse postOpprettVarselEvent(
        List<UN_OpprettVarselEvent> opprettVarselEvents,
        Boolean isSystemContext
    ) {
        ApiController apiCtrl = new ApiController();
        if (isSystemContext == true) {
            apiCtrl.setSystemContext();
        }
        apiCtrl.initRequest(API_CONFIG_NAME, 'UN_POST_OPPRETT_VARSEL_EVENT');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.setBody(JSON.serialize(opprettVarselEvents));
        apiCtrl.doCallout();

        return apiCtrl.getResponse();
    }
}
