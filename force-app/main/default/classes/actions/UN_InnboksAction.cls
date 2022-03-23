public inherited sharing class UN_InnboksAction {
    @InvocableMethod(
        label='Create Innboks Notification'
        description='Create an innboks notification that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<Response> produceInnboksNotification(List<Input> inputList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        Map<String, Response> response = new Map<String, Response>();

        for (Input input : inputList) {
            String eventId = new Uuid().getValue();
            Response resp = new Response();
            resp.relatedRecordSfId = input.relatedRecordSfId;
            try {
                UN_NokkelInput nokkel = new UN_NokkelInputBuilder()
                    .withEventId(eventId)
                    .withFodselsnummer(input.fodselsnummer)
                    .withGrupperingsId(input.grupperingsId)
                    .withNamespace(input.namespace)
                    .withAppnavn(input.appnavn)
                    .build();
                UN_InnboksInput innboks = new UN_InnboksInputBuilder()
                    .withLink(input.link)
                    .withSikkerhetsnivaa(input.sikkerhetsnivaa)
                    .withTekst(input.tekst)
                    .withTidspunkt(input.tidspunkt)
                    .withEksternVarsling(input.eksternVarsling)
                    .withPrefererteKanaler(input.prefererteKanaler)
                    .withEpostVarslingstekst(input.epostVarslingstekst)
                    .withEpostVarslingstittel(input.epostVarslingsttittel)
                    .withSmsVarslingstekst(input.smsVarslingstekst)
                    .build();

                UserNotification__c un = new UserNotification__c();
                un.CRM_Account__c = input.accountId;
                UN_InnboksMapper.innboksInputToUserNotification(innboks, un);
                UN_NokkelMapper.nokkelInputToUserNotification(nokkel, un);
                resp.userNotification = un;
                userNotifications.add(un);
            } catch (Exception e) {
                resp.errorMessage = e.getMessage();
                resp.success = false;
            }
            response.put(eventId, resp);
        }

        Integer index = 0;
        for (Database.SaveResult sr : Database.insert(userNotifications, false)) {
            String key = UN_NokkelMapper.userNotificationToNokkelInput(userNotifications[index]).eventId;
            if (sr.isSuccess()) {
                response.get(key).success = true;
            } else {
                response.get(key).success = false;
                response.get(key).errorMessage = sr.getErrors()[0].getMessage();
            }
            index++;
        }

        return response.values();
    }

    public class Input {
        @InvocableVariable(label='Tidspunkt' required=true)
        public Datetime tidspunkt;
        @InvocableVariable(label='Fodselsnummer' required=true)
        public String fodselsnummer;
        @InvocableVariable(label='Grupperings Id' required=true)
        public String grupperingsId;
        @InvocableVariable(label='Namespace' required=false)
        public String namespace;
        @InvocableVariable(label='App navn' required=false)
        public String appnavn;
        @InvocableVariable(label='Tekst' required=true)
        public String tekst;
        @InvocableVariable(label='Link' required=false)
        public String link;
        @InvocableVariable(label='Sikkerhetsnivå' required=false)
        public Integer sikkerhetsnivaa;
        @InvocableVariable(label='Related SF Record Id' required=false)
        public String relatedRecordSfId;
        @InvocableVariable(label='Event Id' required=false)
        public String eventId;
        @InvocableVariable(label='Account Id' required=true)
        public String accountId;
        @InvocableVariable(label='Prefererte kanaler' required=false)
        public String prefererteKanaler;
        @InvocableVariable(label='Ekstern varsling' required=false)
        public Boolean eksternVarsling;
        @InvocableVariable(label='SMS Varslingstekst' required=false)
        public String smsVarslingstekst;
        @InvocableVariable(label='Epost Varslingstekst' required=false)
        public String epostVarslingstekst;
        @InvocableVariable(label='Epost Varslingstittel' required=false)
        public String epostVarslingsttittel;
    }

    public class Response {
        @InvocableVariable(label='User Notification' required=false)
        public UserNotification__c userNotification;
        @InvocableVariable(label='Related Record Id' required=false)
        public String relatedRecordSfId;
        @InvocableVariable(label='Is success' required=false)
        public Boolean success;
        @InvocableVariable(label='Error Message' required=false)
        public String errorMessage;
    }
}
