public with sharing class UserNotification_OppgaveKafkaHandler extends UserNotification_KafkaHandler {
    protected override void buildNotification(String decodedValue, UserNotification__c notification) {
        UserNotification_Oppgave oppgave = (UserNotification_Oppgave) JSON.deserialize(
            decodedValue,
            UserNotification_Oppgave.class
        );

        emptyFieldValues(notification);

        notification.INT_EventTime__c = UserNotification_Util.longTimeToDateTime(oppgave.tidspunkt);
        notification.INT_SocialSecurityNumber__c = oppgave.fodselsnummer;
        notification.INT_GroupingId__c = oppgave.grupperingsId;
        notification.INT_Description__c = oppgave.tekst;
        notification.INT_Link__c = oppgave.link;
        notification.INT_SecurityLevel__c = oppgave.sikkerhetsnivaa;
        notification.INT_ExternalNotification__c = cleanBoolean(oppgave.eksternVarsling);

        notification.INT_Type__c = 'OPPGAVE';
    }
}
