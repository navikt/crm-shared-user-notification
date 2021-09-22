public with sharing class UN_BeskjedKafkaHandler extends UN_KafkaHandler {
    protected override void buildNotification(String decodedValue, UserNotification__c notification) {
        UN_BeskjedLegacy beskjed = (UN_BeskjedLegacy) JSON.deserialize(decodedValue, UN_BeskjedLegacy.class);

        emptyFieldValues(notification);

        notification.INT_EventTime__c = UN_Util.longTimeToDateTime(beskjed.tidspunkt);
        notification.INT_SocialSecurityNumber__c = beskjed.fodselsnummer;
        notification.INT_GroupingId__c = beskjed.grupperingsId;
        notification.INT_Description__c = beskjed.tekst;
        notification.INT_Link__c = beskjed.link;
        notification.INT_SecurityLevel__c = beskjed.sikkerhetsnivaa;
        notification.INT_VisibleUntil__c = UN_Util.longTimeToDateTime(beskjed.synligFremTil);
        notification.INT_ExternalNotification__c = cleanBoolean(beskjed.eksternVarsling);
        notification.INT_PreferredChannel__c = UN_Util.listToMultiSelect(beskjed.prefererteKanaler);
        notification.INT_Type__c = 'BESKJED';
    }
}
