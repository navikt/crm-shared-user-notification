public without sharing class UN_InnboksAction {
    @InvocableMethod(
        label='Create Innboks Notification'
        description='Create an innboks notification that appears on Nav.no using Flow-compatible fields.'
        category='User Notification'
    )
    public static List<Response> produceInnboksNotification(List<Input> inputList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        List<UN_InnboksEvent> events = new List<UN_InnboksEvent>();

        for (Input input : inputList) {
            String varselId = String.isNotBlank(input.varselId) ? input.varselId : new Uuid().getValue();

            List<UN_Kanal> prefererteKanaler = UN_NotificationUtils.parseKanalString(input.prefererteKanaler);

            UN_EksternVarsling eksternVarsling = (input.smsVarslingstekst == null &&
                input.epostVarslingstittel == null &&
                input.epostVarslingstekst == null)
                ? new UN_EksternVarsling(prefererteKanaler)
                : new UN_EksternVarsling(
                      prefererteKanaler,
                      input.smsVarslingstekst,
                      input.epostVarslingstittel,
                      input.epostVarslingstekst,
                      input.kanBatches
                  );

            UN_Produsent produsent = (String.isBlank(input.cluster) &&
                String.isBlank(input.namespace) &&
                String.isBlank(input.appnavn))
                ? new UN_Produsent()
                : new UN_Produsent(
                      String.isNotBlank(input.cluster) ? input.cluster : UN_Produsent.DEFAULT_CLUSTER,
                      String.isNotBlank(input.namespace) ? input.namespace : UN_Produsent.DEFAULT_NAMESPACE,
                      String.isNotBlank(input.appnavn) ? input.appnavn : UN_Produsent.DEFAULT_APPNAVN
                  );

            List<UN_Tekst> tekster = String.isNotBlank(input.tekster)
                ? UN_NotificationUtils.parseTekster(input.tekster)
                : new List<UN_Tekst>();

            UN_Sensitivitet sensitivitet = UN_NotificationUtils.sensitivitetIsValid(input.sensitivitet)
                ? UN_Sensitivitet.valueOf(input.sensitivitet.trim().toUpperCase())
                : UN_Sensitivitet.HIGH;

            UN_InnboksEvent innboksEvent = new UN_InnboksEvent(
                varselId,
                input.ident,
                tekster,
                input.link,
                sensitivitet,
                eksternVarsling,
                produsent
            );
            innboksEvent.validate();
            events.add(innboksEvent);

            UserNotification__c un = new UserNotification__c();
            un.CRM_Account__c = input.accountId;
            un.CRM_RelatedSfRecord__c = input.relatedRecordSfId;
            UN_InnboksMapper.mapUserNotificationToInnboksEvent(innboksEvent, un);
            userNotifications.add(un);
        }

        List<Database.SaveResult> results = Database.insert(userNotifications, false);

        List<Response> responses = new List<Response>();
        for (Integer i = 0; i < results.size(); i++) {
            Database.SaveResult sr = results[i];
            Response resp = new Response();
            resp.relatedRecordSfId = inputList[i].relatedRecordSfId;
            resp.userNotification = userNotifications[i];
            resp.success = sr.isSuccess();
            resp.errorMessage = sr.isSuccess()
                ? null
                : ((sr.getErrors() != null &&
                      sr.getErrors().size() > 0)
                      ? sr.getErrors()[0].getMessage()
                      : 'Unknown error');
            responses.add(resp);
        }
        return responses;
    }

    public class Input {
        @InvocableVariable(label='Varsel Id' required=false)
        public String varselId;
        @InvocableVariable(label='Ident' required=true)
        public String ident;
        @InvocableVariable(label='Tekster' required=true)
        public String tekster;
        @InvocableVariable(label='Link' required=false)
        public String link;
        @InvocableVariable(label='Sensitivitet' required=false)
        public String sensitivitet;
        @InvocableVariable(label='Prefererte Kanaler' required=false)
        public String prefererteKanaler;
        @InvocableVariable(label='SMS Varslingstekst' required=false)
        public String smsVarslingstekst;
        @InvocableVariable(label='Epost Varslingstittel' required=false)
        public String epostVarslingstittel;
        @InvocableVariable(label='Epost Varslingstekst' required=false)
        public String epostVarslingstekst;
        @InvocableVariable(label='Kan Batches' required=false)
        public Boolean kanBatches;
        @InvocableVariable(label='Cluster' required=false)
        public String cluster;
        @InvocableVariable(label='Namespace' required=false)
        public String namespace;
        @InvocableVariable(label='Appnavn' required=false)
        public String appnavn;
        @InvocableVariable(label='Account Id' required=true)
        public String accountId;
        @InvocableVariable(label='Related Record Sf Id' required=false)
        public String relatedRecordSfId;
    }
    public class Response {
        @InvocableVariable
        public UserNotification__c userNotification;
        @InvocableVariable
        public String relatedRecordSfId;
        @InvocableVariable
        public Boolean success;
        @InvocableVariable
        public String errorMessage;
    }
}
