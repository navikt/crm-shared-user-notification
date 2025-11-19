public with sharing class UN_UserNotificationService {
    private final static String API_CONFIG_NAME = 'UN_SF_BRUKERNOTIFIKASJONER';
    private final static String SERVICE_AUTH_HEADER = 'sfBrukernotifikasjon';

    public static HttpResponse postOpprettVarselEvent(
        UN_OpprettVarselEvent opprettVarselEvent,
        Boolean isSystemContext
    ) {
        Map<String, Object> payload = buildEventPayload(opprettVarselEvent);
        ApiController apiCtrl = new ApiController();
        if (isSystemContext)
            apiCtrl.setSystemContext();
        apiCtrl.initRequest(API_CONFIG_NAME, 'UN_POST_OPPRETT_VARSEL_EVENT');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.setBody(JSON.serialize(payload));
        apiCtrl.doCallout();
        return apiCtrl.getResponse();
    }

    private static Map<String, Object> buildEventPayload(UN_OpprettVarselEvent event) {
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('@event_name', 'opprett');
        payload.put('type', event.type != null ? event.type.name().toLowerCase() : null);
        payload.put('varselId', event.varselId);
        payload.put('ident', event.ident);

        if (event.tekster != null && !event.tekster.isEmpty()) {
            List<Map<String, Object>> teksterList = new List<Map<String, Object>>();
            for (UN_Tekst t : event.tekster) {
                teksterList.add(
                    new Map<String, Object>{
                        'spraakkode' => t.spraakkode,
                        'tekst' => t.tekst,
                        'default' => t.defaultValue
                    }
                );
            }
            payload.put('tekster', teksterList);
        }

        payload.put('link', event.link);
        payload.put('sensitivitet', event.sensitivitet != null ? event.sensitivitet.name().toLowerCase() : null);
        payload.put('aktivFremTil', event.aktivFremTil);

        if (event.eksternVarsling != null) {
            payload.put(
                'eksternVarsling',
                new Map<String, Object>{
                    'prefererteKanaler' => event.eksternVarsling.prefererteKanaler != null
                        ? UN_NotificationUtils.kanalerToString(event.eksternVarsling.prefererteKanaler).split(';')
                        : new List<String>(),
                    'smsVarslingstekst' => event.eksternVarsling.smsVarslingstekst,
                    'epostVarslingstittel' => event.eksternVarsling.epostVarslingstittel,
                    'epostVarslingstekst' => event.eksternVarsling.epostVarslingstekst,
                    'kanBatches' => event.eksternVarsling.kanBatches
                }
            );
        }

        if (event.produsent != null) {
            payload.put(
                'produsent',
                new Map<String, Object>{
                    'cluster' => event.produsent.cluster,
                    'namespace' => event.produsent.namespace,
                    'appnavn' => event.produsent.appnavn
                }
            );
        }
        return payload;
    }
}
