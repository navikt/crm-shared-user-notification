public inherited sharing class UN_DittNavEventHandlerService {
    private static final String API_CONFIG_NAME = 'DITTNAV_EVENT_HANDLER_PROXY';

    public static HttpResponse fetchEvents(String ident, UN_DittNavEventType eventType, UN_DittNavEventFilter filter) {
        ApiController apiCtrl = new ApiController();
        apiCtrl.initRequest(
            API_CONFIG_NAME,
            'DITTNAV_EVENT_FETCH',
            new Map<String, String>{
                'eventType' => eventType.name().toLowerCase(),
                'filter' => filter.name().toLowerCase()
            }
        );
        apiCtrl.setSystemContext();
        apiCtrl.addServiceAuthHeader('DittNavEventHandler');
        apiCtrl.addHeader('fodselsnummer', ident);
        apiCtrl.doCallout();
        return apiCtrl.getResponse();
    }
}
