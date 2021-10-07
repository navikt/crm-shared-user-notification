public with sharing class UN_InnboksMapper {
    // public static UN_InnboksLegacy userNotificationToInnboksLegacy(UserNotification__c userNotification) {
    //     UN_InnboksLegacy innboks = new UN_InnboksLegacy();

    //     innboks.grupperingsId = userNotification.INT_GroupingId__c;
    //     innboks.fodselsnummer = userNotification.INT_SocialSecurityNumber__c;
    //     innboks.link = userNotification.INT_Link__c;
    //     innboks.sikkerhetsnivaa = userNotification.INT_SecurityLevel__c.intValue();
    //     innboks.tekst = userNotification.INT_Description__c;
    //     innboks.tidspunkt = userNotification.INT_EventTime__c;

    //     return innboks;
    // }

    // public static UserNotification__c innboksLegacyToUserNotification(UN_InnboksLegacy innboks) {
    //     return innboksLegacyToUserNotification(innboks, new UserNotification__c());
    // }

    public static UserNotification__c innboksLegacyToUserNotification(
        UN_InnboksLegacy innboks,
        UserNotification__c userNotification
    ) {
        userNotification.INT_GroupingId__c = innboks.grupperingsId;
        userNotification.INT_SocialSecurityNumber__c = innboks.fodselsnummer;
        userNotification.INT_Link__c = innboks.link;
        userNotification.INT_SecurityLevel__c = innboks.sikkerhetsnivaa;
        userNotification.INT_Description__c = innboks.tekst;
        userNotification.INT_EventTime__c = innboks.tidspunkt;
        userNotification.INT_Type__c = 'INNBOKS';
        userNotification.INT_PreferredChannel__c = UN_Util.stringToMultiSelect(innboks.prefererteKanaler, ',');
        userNotification.INT_ExternalNotification__c = innboks.eksternVarsling;

        return userNotification;
    }
}