public inherited sharing class UN_TmsEventApi {
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

    private List<UN_TmsEventApiEvent> getEvents(
        String ident,
        UN_TmsEventApiEventType eventType,
        UN_TmsEventApiEventFilter filter
    ) {
        HttpResponse response = UN_TmsEventApiService.fetchEvents(ident, eventType, filter);

        if (response.getStatusCode() == 200) {
            switch on eventType {
                when INNBOKS {
                    return (List<UN_TmsEventApiInnboks>) JSON.deserialize(
                        response.getBody(),
                        List<UN_TmsEventApiInnboks>.class
                    );
                }
                when BESKJED {
                    return (List<UN_TmsEventApiBeskjed>) JSON.deserialize(
                        response.getBody(),
                        List<UN_TmsEventApiBeskjed>.class
                    );
                }
                when OPPGAVE {
                    return (List<UN_TmsEventApiOppgave>) JSON.deserialize(
                        response.getBody(),
                        List<UN_TmsEventApiOppgave>.class
                    );
                }
                when else {
                }
            }

            return (List<UN_TmsEventApiEvent>) JSON.deserialize(response.getBody(), List<UN_TmsEventApiEvent>.class);
        }

        return null;
    }
}
