public with sharing class UN_EventMapper {
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
        userNotification.INT_Preferred_Channel__c = (innboksEvent.eksternVarsling != null &&
            innboksEvent.eksternVarsling.preferertKanal != null)
            ? innboksEvent.eksternVarsling.preferertKanal.name()
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
        UN_Kanal kanal = userNotification.INT_Preferred_Channel__c != null
            ? UN_Kanal.valueOf(userNotification.INT_Preferred_Channel__c.trim().toUpperCase())
            : null;

        UN_EksternVarsling eksternVarsling = null;
        if (kanal != null) {
            eksternVarsling = (String.isNotBlank(userNotification.INT_SmsText__c) &&
                String.isNotBlank(userNotification.INT_EmailSubject__c) &&
                String.isNotBlank(userNotification.INT_EmailBody__c))
                ? new UN_EksternVarsling(
                      kanal,
                      userNotification.INT_SmsText__c,
                      userNotification.INT_EmailSubject__c,
                      userNotification.INT_EmailBody__c,
                      false
                  )
                : new UN_EksternVarsling(kanal);
        }

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

    public static UserNotification__c mapUserNotificationToInaktiverEvent(
        UN_InaktiverEvent inaktiver,
        UserNotification__c userNotification
    ) {
        userNotification.CRM_Done__c = true;

        return userNotification;
    }

    public static UN_InaktiverEvent createInaktiverEventFromUserNotification(UserNotification__c userNotification) {
        UN_Produsent produsent = (String.isNotBlank(userNotification.INT_Namespace__c) &&
            String.isNotBlank(userNotification.INT_AppName__c))
            ? new UN_Produsent(
                  UN_Produsent.DEFAULT_CLUSTER,
                  userNotification.INT_Namespace__c,
                  userNotification.INT_AppName__c
              )
            : new UN_Produsent();

        return new UN_InaktiverEvent(userNotification.INT_EventId__c, produsent);
    }
}
