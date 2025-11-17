public without sharing class UN_InnboksAction {
    @InvocableMethod(
        label='Create Innboks Notification'
        description='Create an innboks notification that appears on Nav.no using Flow-compatible fields.'
        category='User Notification'
    )
    public static List<Response> produceInnboksNotification(List<Input> inputList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        List<String> varselIds = new List<String>();

        for (Input input : inputList) {
            String varselId = (input.varselId != null && input.varselId != '') ? input.varselId : new Uuid().getValue();

            List<String> prefererteKanaler = new List<String>();
            if (input.prefererteKanaler != null && input.prefererteKanaler != '') {
                for (String val : input.prefererteKanaler.split(';')) {
                    String trimmedVal = val.trim();
                    if (trimmedVal != '') {
                        prefererteKanaler.add(trimmedVal);
                    }
                }
            }
            UN_EksternVarsling eksternVarsling = new UN_EksternVarsling(
                prefererteKanaler,
                input.smsVarslingstekst,
                input.epostVarslingstittel,
                input.epostVarslingstekst,
                input.kanBatches
            );

            UN_Produsent produsent = new UN_Produsent(input.cluster, input.namespace, input.appnavn);

            List<UN_Tekst> tekster = new List<UN_Tekst>();
            if (input.tekster != null && input.tekster != '') {
                List<String> tekstList = input.tekster.split(',|;');
                for (Integer idx = 0; idx < tekstList.size(); idx++) {
                    tekster.add(new UN_Tekst('no', tekstList[idx], idx == 0));
                }
            }

            UN_InnboksEvent innboksEvent = new UN_InnboksEvent(
                varselId,
                input.ident,
                tekster,
                input.link,
                input.sensitivitet,
                eksternVarsling,
                produsent
            );

            UserNotification__c un = new UserNotification__c();
            un.CRM_Account__c = input.accountId;
            un.CRM_RelatedSfRecord__c = input.relatedRecordSfId;
            UN_InnboksMapper.mapUserNotificationToInnboksEvent(innboksEvent, un);
            userNotifications.add(un);
            varselIds.add(varselId);
        }

        List<Response> responses = new List<Response>();
        Integer idx = 0;
        for (Database.SaveResult sr : Database.insert(userNotifications, false)) {
            Response resp = new Response();
            resp.relatedRecordSfId = inputList[idx].relatedRecordSfId;
            resp.userNotification = userNotifications[idx];
            resp.success = sr.isSuccess();
            resp.errorMessage = sr.isSuccess()
                ? null
                : ((sr.getErrors() != null &&
                      sr.getErrors().size() > 0)
                      ? sr.getErrors()[0].getMessage()
                      : 'Unknown error');
            responses.add(resp);
            idx++;
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
