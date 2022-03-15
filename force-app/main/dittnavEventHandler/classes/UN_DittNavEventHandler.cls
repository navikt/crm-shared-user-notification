public inherited sharing class UN_DittNavEventHandler {
    @AuraEnabled
    public static List<UN_DittNavEvent> getAllEventsAura(String ident) {
        try {
            return new UN_DittNavEventHandler().getAllEvents(ident);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public List<UN_DittNavEvent> getAllEvents(String ident) {
        List<UN_DittNavEvent> events = new List<UN_DittNavEvent>();

        events.addAll(getEvents(ident, UN_DittNavEventType.INNBOKS, UN_DittNavEventFilter.ALL));
        events.addAll(getEvents(ident, UN_DittNavEventType.BESKJED, UN_DittNavEventFilter.ALL));
        events.addAll(getEvents(ident, UN_DittNavEventType.OPPGAVE, UN_DittNavEventFilter.ALL));

        return events;
    }

    private List<UN_DittNavEvent> getEvents(String ident, UN_DittNavEventType eventType, UN_DittNavEventFilter filter) {
        HttpResponse response = UN_DittNavEventHandlerService.fetchEvents(ident, eventType, filter);

        if (response.getStatusCode() == 200) {
            return (List<UN_DittNavEvent>) JSON.deserialize(response.getBody(), List<UN_DittNavEvent>.class);
        }

        return null;
    }
}
