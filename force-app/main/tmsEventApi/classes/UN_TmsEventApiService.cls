public inherited sharing class UN_TmsEventApiService {
    private static final String API_CONFIG_NAME = 'TMS_EVENT_API';
    private static final String API_SERVICE_NAME = 'TMS_SERVICE_PATH';

    public static HttpResponse fetchEvents(
        String ident,
        UN_TmsEventApiEventType eventType,
        UN_TmsEventApiEventFilter filter
    ) {
        ApiController apiCtrl = new ApiController();
        apiCtrl.initRequest(
            API_CONFIG_NAME,
            API_SERVICE_NAME,
            new Map<String, String>{
                'eventType' => eventType.name().toLowerCase(),
                'filter' => filter.name().toLowerCase()
            }
        );
        apiCtrl.setSystemContext();
        apiCtrl.addServiceAuthHeader('TmsEventApi');
        apiCtrl.addHeader('fodselsnummer', ident);
        apiCtrl.doCallout();
        return apiCtrl.getResponse();
    }
}
