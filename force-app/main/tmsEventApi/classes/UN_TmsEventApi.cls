public inherited sharing class UN_TmsEventApi {
    @TestVisible
    private final static Set<String> PRODUCERS_TO_SKIP = new Set<String>{
        'sosialhjelp-dialog-api',
        'sosialhjelp-dialog-api-dev'
    };

    @AuraEnabled
    public static List<UN_TmsEventApiEvent> getAllEventsAura(String ident) {
        try {
            return new UN_TmsEventApi().getAllEvents(ident);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public List<UN_TmsEventApiEvent> getAllEvents(String ident) {
        List<UN_TmsEventApiEvent> events = new List<UN_TmsEventApiEvent>();

        events.addAll(getEvents(ident, UN_TmsEventApiEventType.INNBOKS, UN_TmsEventApiEventFilter.ALL));
        events.addAll(getEvents(ident, UN_TmsEventApiEventType.BESKJED, UN_TmsEventApiEventFilter.ALL));
        events.addAll(getEvents(ident, UN_TmsEventApiEventType.OPPGAVE, UN_TmsEventApiEventFilter.ALL));

        return events;
    }

    public List<UN_TmsEventApiEvent> getEvents(
        String ident,
        UN_TmsEventApiEventType eventType,
        UN_TmsEventApiEventFilter filter
    ) {
        HttpResponse response = UN_TmsEventApiService.fetchEvents(ident, eventType, filter);

        List<UN_TmsEventApiEvent> eventList = new List<UN_TmsEventApiEvent>();
        if (response.getStatusCode() == 200) {
            for (
                UN_TmsEventApiEvent tmsEvent : (List<UN_TmsEventApiEvent>) JSON.deserialize(
                    response.getBody(),
                    List<UN_TmsEventApiEvent>.class
                )
            ) {
                if (PRODUCERS_TO_SKIP.contains(tmsEvent.produsent)) {
                    continue;
                }
                switch on eventType {
                    when INNBOKS {
                        tmsEvent.type = 'INNBOKS';
                        tmsEvent.typeLabel = 'Innboks';
                        eventList.add(tmsEvent);
                    }
                    when BESKJED {
                        tmsEvent.type = 'BESKJED';
                        tmsEvent.typeLabel = 'Beskjed';
                        eventList.add(tmsEvent);
                    }
                    when OPPGAVE {
                        tmsEvent.type = 'OPPGAVE';
                        tmsEvent.typeLabel = 'Oppgave';
                        eventList.add(tmsEvent);
                    }
                }
            }
            return eventList;
        }
        return null;
    }
}
