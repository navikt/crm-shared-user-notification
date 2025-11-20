public with sharing class UN_InnboksMapper {
    public static void mapUserNotificationToInnboksEvent(
        UN_InnboksEvent innboksEvent,
        UserNotification__c userNotification
    ) {
        userNotification.INT_Type__c = innboksEvent.type != null ? innboksEvent.type.name() : null;
        userNotification.INT_EventId__c = innboksEvent.varselId;
        userNotification.INT_SocialSecurityNumber__c = innboksEvent.ident;
        userNotification.INT_Description__c = UN_NotificationUtils.serializeTekster(innboksEvent.tekster);
        userNotification.INT_Link__c = innboksEvent.link;
        userNotification.INT_Sensitivity__c = innboksEvent.sensitivitet != null
            ? innboksEvent.sensitivitet.name().toLowerCase()
            : null;
        userNotification.INT_PreferredChannel__c = (innboksEvent.eksternVarsling != null &&
            innboksEvent.eksternVarsling.prefererteKanaler != null)
            ? UN_NotificationUtils.kanalerToString(innboksEvent.eksternVarsling.prefererteKanaler)
            : null;
        userNotification.INT_SmsText__c = (innboksEvent.eksternVarsling != null)
            ? innboksEvent.eksternVarsling.smsVarslingstekst
            : null;
        userNotification.INT_EmailSubject__c = (innboksEvent.eksternVarsling != null)
            ? innboksEvent.eksternVarsling.epostVarslingstittel
            : null;
        userNotification.INT_EmailBody__c = (innboksEvent.eksternVarsling != null)
            ? innboksEvent.eksternVarsling.epostVarslingstekst
            : null;
        userNotification.INT_Namespace__c = (innboksEvent.produsent != null) ? innboksEvent.produsent.namespace : null;
        userNotification.INT_AppName__c = (innboksEvent.produsent != null) ? innboksEvent.produsent.appnavn : null;
        userNotification.INT_Key__c =
            (userNotification.INT_AppName__c != null ? userNotification.INT_AppName__c + '.' : '') +
            (userNotification.INT_Namespace__c != null ? userNotification.INT_Namespace__c + '.' : '') +
            (userNotification.INT_EventId__c != null ? userNotification.INT_EventId__c : '');
    }

    public static UN_InnboksEvent createInnboksEventFromUserNotification(UserNotification__c userNotification) {
        List<UN_Tekst> tekster = UN_NotificationUtils.parseTekster(userNotification.INT_Description__c);
        List<UN_Kanal> kanaler = UN_NotificationUtils.parseKanalString(userNotification.INT_PreferredChannel__c);

        UN_EksternVarsling eksternVarsling = (String.isNotBlank(userNotification.INT_SmsText__c) &&
            String.isNotBlank(userNotification.INT_EmailSubject__c) &&
            String.isNotBlank(userNotification.INT_EmailBody__c))
            ? new UN_EksternVarsling(
                  kanaler,
                  userNotification.INT_SmsText__c,
                  userNotification.INT_EmailSubject__c,
                  userNotification.INT_EmailBody__c,
                  false // sjekk verdien her
              )
            : new UN_EksternVarsling(kanaler);

        UN_Produsent produsent = (String.isNotBlank(userNotification.INT_Namespace__c) &&
            String.isNotBlank(userNotification.INT_AppName__c))
            ? new UN_Produsent(
                  UN_Produsent.DEFAULT_CLUSTER,
                  userNotification.INT_Namespace__c,
                  userNotification.INT_AppName__c
              )
            : new UN_Produsent();

        UN_Sensitivitet sensitivitet = UN_NotificationUtils.sensitivitetIsValid(userNotification.INT_Sensitivity__c)
            ? UN_Sensitivitet.valueOf(userNotification.INT_Sensitivity__c.trim().toUpperCase())
            : UN_Sensitivitet.HIGH;

        return new UN_InnboksEvent(
            userNotification.INT_EventId__c,
            userNotification.INT_SocialSecurityNumber__c,
            tekster,
            userNotification.INT_Link__c,
            sensitivitet,
            eksternVarsling,
            produsent
        );
    }
}
