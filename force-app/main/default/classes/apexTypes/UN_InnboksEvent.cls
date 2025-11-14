public inherited sharing class UN_InnboksEvent extends UN_OpprettVarselEvent {
    public UN_InnboksEvent(
        String varselId,
        String ident,
        List<UN_Tekst> tekster,
        String link,
        String sensitivitet,
        UN_EksternVarsling eksternVarsling,
        UN_Produsent produsent
    ) {
        super(
            'innboks',
            varselId,
            ident,
            tekster,
            link,
            sensitivitet,
            null, // aktivFremTil is not supported for innboks
            eksternVarsling,
            produsent
        );
    }

    public UN_InnboksEvent(UserNotification__c userNotification) {
        super(
            'innboks',
            userNotification.INT_EventId__c,
            userNotification.INT_SocialSecurityNumber__c,
            mapToTekster(userNotification.INT_Description__c),
            userNotification.INT_Link__c,
            userNotification.INT_Sensitivity__c,
            null,
            new UN_EksternVarsling(
                (userNotification.INT_PreferredChannel__c != null
                    ? userNotification.INT_PreferredChannel__c.split(',')
                    : new List<String>()),
                userNotification.INT_SmsText__c,
                userNotification.INT_EmailSubject__c,
                userNotification.INT_EmailBody__c,
                false // or fetch value as needed
            ),
            new UN_Produsent(
                'CRM', // må sjekkes hva som er riktig verdi her
                userNotification.INT_Namespace__c,
                userNotification.INT_AppName__c
            )
        );
    }

    private static List<UN_Tekst> mapToTekster(String description) {
        List<UN_Tekst> tekster = new List<UN_Tekst>();
        if (description != null) {
            List<String> parts = description.split(';');
            Integer i = 0;
            for (String txt : parts) {
                tekster.add(new UN_Tekst('no', txt.trim(), i == 0));
                i++;
            }
        }
        return tekster;
    }
}
