public with sharing class UserNotification_StatusKafkaHandler extends UserNotification_KafkaHandler {
    protected override void buildNotification(String decodedValue, UserNotification__c notification) {
        UserNotification_Statusoppdatering statusoppdatering = (UserNotification_Statusoppdatering) JSON.deserialize(
            decodedValue,
            UserNotification_Statusoppdatering.class
        );

        emptyFieldValues(notification);

        notification.INT_EventTime__c = UserNotification_Util.longTimeToDateTime(statusoppdatering.tidspunkt);
        notification.INT_SocialSecurityNumber__c = statusoppdatering.fodselsnummer;
        notification.INT_GroupingId__c = statusoppdatering.grupperingsId;
        notification.INT_Description__c = statusoppdatering.statusIntern;
        notification.INT_Link__c = statusoppdatering.link;
        notification.INT_SecurityLevel__c = statusoppdatering.sikkerhetsnivaa;
        notification.INT_GlobalStatus__c = statusoppdatering.statusGlobal;
        notification.INT_InternalStatus__c = statusoppdatering.statusIntern;
        notification.INT_CaseTheme__c = statusoppdatering.sakstema;
        notification.INT_ExternalNotification__c = false;

        notification.INT_Type__c = 'STATUSOPPDATERING';
        notification.CRM_CaseTheme__c = commonCodeMap.get(statusoppdatering.sakstema);
    }
}
