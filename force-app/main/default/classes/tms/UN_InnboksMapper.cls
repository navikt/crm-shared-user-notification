public with sharing class UN_InnboksMapper {
    public static void mapUserNotificationToInnboksEvent(
        UN_InnboksEvent innboksEvent,
        UserNotification__c userNotification
    ) {
        userNotification.INT_Type__c = innboksEvent.type;
        userNotification.INT_EventId__c = innboksEvent.varselId;
        userNotification.INT_SocialSecurityNumber__c = innboksEvent.ident;
        List<String> tekstValues = new List<String>();
        for (UN_Tekst t : innboksEvent.tekster) {
            tekstValues.add(t.tekst);
        }
        userNotification.INT_Description__c = String.join(tekstValues, '; ');
        userNotification.INT_Link__c = innboksEvent.link;
        userNotification.INT_Sensitivity__c = innboksEvent.sensitivitet;
        userNotification.INT_PreferredChannel__c = String.join(innboksEvent.eksternVarsling.prefererteKanaler, '; ');
        userNotification.INT_SmsText__c = innboksEvent.eksternVarsling.smsVarslingstekst;
        userNotification.INT_EmailSubject__c = innboksEvent.eksternVarsling.epostVarslingstittel;
        userNotification.INT_EmailBody__c = innboksEvent.eksternVarsling.epostVarslingstekst;
        userNotification.INT_Namespace__c = innboksEvent.produsent.namespace;
        userNotification.INT_AppName__c = innboksEvent.produsent.appnavn;
        userNotification.INT_Key__c =
            innboksEvent.produsent.appnavn +
            innboksEvent.produsent.namespace +
            innboksEvent.varselId;
    }

    public static UN_InnboksEvent createInnboksEventFromUserNotification(UserNotification__c userNotification) {
        List<UN_Tekst> tekster = new List<UN_Tekst>();
        if (userNotification.INT_Description__c != null) {
            List<String> teksterStr = userNotification.INT_Description__c.split(';');
            Integer idx = 0;
            for (String t : teksterStr) {
                tekster.add(new UN_Tekst('no', t.trim(), idx == 0));
                idx++;
            }
        }
        List<String> kanaler = new List<String>();
        if (userNotification.INT_PreferredChannel__c != null) {
            for (String kanal : userNotification.INT_PreferredChannel__c.split(';')) {
                String trimmed = kanal.trim();
                if (trimmed != '')
                    kanaler.add(trimmed);
            }
        }
        UN_EksternVarsling eksternVarsling = new UN_EksternVarsling(
            kanaler,
            userNotification.INT_SmsText__c,
            userNotification.INT_EmailSubject__c,
            userNotification.INT_EmailBody__c,
            false
        );
        UN_Produsent produsent = new UN_Produsent(
            'CRM', // må sjekkes hva som er riktig verdi her
            userNotification.INT_Namespace__c,
            userNotification.INT_AppName__c
        );
        return new UN_InnboksEvent(
            userNotification.INT_EventId__c,
            userNotification.INT_SocialSecurityNumber__c,
            tekster,
            userNotification.INT_Link__c,
            userNotification.INT_Sensitivity__c,
            eksternVarsling,
            produsent
        );
    }
}
