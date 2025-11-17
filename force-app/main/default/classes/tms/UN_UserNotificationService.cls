public with sharing class UN_UserNotificationService {
    private final static string API_CONFIG_NAME = 'UN_SF_BRUKERNOTIFIKASJONER';
    private final static string SERVICE_AUTH_HEADER = 'sfBrukernotifikasjon';

    public static HttpResponse postOpprettVarselEvent(
        List<UN_OpprettVarselEvent> opprettVarselEvents,
        Boolean isSystemContext
    ) {
        List<Map<String, Object>> payloadList = new List<Map<String, Object>>();
        for (UN_OpprettVarselEvent event : opprettVarselEvents) {
            payloadList.add(buildEventPayload(event));
        }
        ApiController apiCtrl = new ApiController();
        if (isSystemContext == true) {
            apiCtrl.setSystemContext();
        }
        apiCtrl.initRequest(API_CONFIG_NAME, 'UN_POST_OPPRETT_VARSEL_EVENT');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');

        apiCtrl.setBody(JSON.serialize(payloadList));
        apiCtrl.doCallout();
        return apiCtrl.getResponse();
    }

    private static Map<String, Object> buildEventPayload(UN_OpprettVarselEvent event) {
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('@event_name', 'opprett');
        payload.put('type', event.type);
        payload.put('varselId', event.varselId);
        payload.put('ident', event.ident);

        List<Map<String, Object>> teksterList = new List<Map<String, Object>>();
        for (UN_Tekst t : event.tekster) {
            Map<String, Object> tekstMap = new Map<String, Object>{
                'spraakkode' => t.spraakkode,
                'tekst' => t.tekst,
                'default' => t.defaultValue
            };
            teksterList.add(tekstMap);
        }
        payload.put('tekster', teksterList);
        payload.put('link', event.link);
        payload.put('sensitivitet', event.sensitivitet);
        payload.put('aktivFremTil', event.aktivFremTil);

        if (event.eksternVarsling != null) {
            Map<String, Object> eksternVarslingMap = new Map<String, Object>{
                'prefererteKanaler' => event.eksternVarsling.prefererteKanaler,
                'smsVarslingstekst' => event.eksternVarsling.smsVarslingstekst,
                'epostVarslingstittel' => event.eksternVarsling.epostVarslingstittel,
                'epostVarslingstekst' => event.eksternVarsling.epostVarslingstekst,
                'kanBatches' => event.eksternVarsling.kanBatches
            };
            payload.put('eksternVarsling', eksternVarslingMap);
        }

        if (event.produsent != null) {
            Map<String, Object> produsentMap = new Map<String, Object>{
                'cluster' => event.produsent.cluster,
                'namespace' => event.produsent.namespace,
                'appnavn' => event.produsent.appnavn
            };
            payload.put('produsent', produsentMap);
        }

        // log for test
        LoggerUtility logger = new LoggerUtility('User Notification');
        logger.info('UN_UserNotificationService payload: ' + JSON.serialize(payload), null);
        logger.publish();
        return payload;
    }
}
