public with sharing class UN_UserNotificationService {
    private final static String API_CONFIG_NAME = 'UN_SF_BRUKERNOTIFIKASJONER';
    private final static String SERVICE_AUTH_HEADER = 'sfBrukernotifikasjon';

    public static HttpResponse postOpprettVarselEvent(
        UN_OpprettVarselEvent opprettVarselEvent,
        Boolean isSystemContext
    ) {
        Map<String, Object> payload = buildEventPayload(opprettVarselEvent);
        UN_NotificationUtils.removeNulls(payload);
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

    public static HttpResponse postInaktiverVarselEvent(UN_InaktiverEvent inaktiverEvent, Boolean isSystemContext) {
        Map<String, Object> payload = buildInaktiverEventPayload(inaktiverEvent);
        ApiController apiCtrl = new ApiController();
        if (isSystemContext)
            apiCtrl.setSystemContext();
        apiCtrl.initRequest(API_CONFIG_NAME, 'UN_POST_INAKTIVER_VARSEL_EVENT');
        apiCtrl.addServiceAuthHeader(SERVICE_AUTH_HEADER);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.setBody(JSON.serialize(payload));
        apiCtrl.doCallout();
        return apiCtrl.getResponse();
    }

    @TestVisible
    private static Map<String, Object> buildEventPayload(UN_OpprettVarselEvent event) {
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('@event_name', 'opprett');
        payload.put('type', event.type != null ? event.type.name().toLowerCase() : null);
        payload.put('varselId', event.varselId);
        payload.put('ident', event.ident);

        if (event.tekster != null && !event.tekster.isEmpty()) {
            List<Map<String, Object>> teksterList = new List<Map<String, Object>>();
            for (UN_Tekst t : event.tekster) {
                Map<String, Object> tekstMap = new Map<String, Object>{
                    'spraakkode' => t.spraakkode,
                    'tekst' => t.tekst,
                    'default' => t.defaultValue
                };
                if (!tekstMap.isEmpty()) {
                    teksterList.add(tekstMap);
                }
            }
            payload.put('tekster', teksterList);
        }

        payload.put('link', event.link);
        payload.put('sensitivitet', event.sensitivitet != null ? event.sensitivitet.name().toLowerCase() : null);
        payload.put('aktivFremTil', event.aktivFremTil);

        if (event.eksternVarsling != null) {
            Map<String, Object> eksternVarslingMap = new Map<String, Object>();

            if (event.eksternVarsling.prefererteKanaler != null && !event.eksternVarsling.prefererteKanaler.isEmpty()) {
                List<String> kanalList = new List<String>();
                for (UN_Kanal kanal : event.eksternVarsling.prefererteKanaler) {
                    kanalList.add(kanal.name());
                }
                eksternVarslingMap.put('prefererteKanaler', kanalList);
            }

            eksternVarslingMap.put('smsVarslingstekst', event.eksternVarsling.smsVarslingstekst);
            eksternVarslingMap.put('epostVarslingstittel', event.eksternVarsling.epostVarslingstittel);
            eksternVarslingMap.put('epostVarslingstekst', event.eksternVarsling.epostVarslingstekst);
            eksternVarslingMap.put('kanBatches', event.eksternVarsling.kanBatches);

            UN_NotificationUtils.removeNulls(eksternVarslingMap);
            if (!eksternVarslingMap.isEmpty()) {
                payload.put('eksternVarsling', eksternVarslingMap);
            }
        }

        if (event.produsent != null) {
            Map<String, Object> produsentMap = new Map<String, Object>{
                'cluster' => event.produsent.cluster,
                'namespace' => event.produsent.namespace,
                'appnavn' => event.produsent.appnavn
            };
            if (!produsentMap.isEmpty()) {
                payload.put('produsent', produsentMap);
            }
        }
        return payload;
    }

    @TestVisible
    private static Map<String, Object> buildInaktiverEventPayload(UN_InaktiverEvent event) {
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('@event_name', 'inaktiver');
        payload.put('varselId', event.varselId);
        if (event.produsent != null) {
            Map<String, Object> produsentMap = new Map<String, Object>{
                'cluster' => event.produsent.cluster,
                'namespace' => event.produsent.namespace,
                'appnavn' => event.produsent.appnavn
            };
            if (!produsentMap.isEmpty()) {
                payload.put('produsent', produsentMap);
            }
        }
        return payload;
    }
}
