public with sharing class UserNotification_BeskjedBuilder {
    public static UserNotification_Beskjed build(UserNotification__c notification) {
        UserNotification_Beskjed beskjed = new UserNotification_Beskjed();

        beskjed.tidspunkt = UserNotification_BuilderValidationUtil.localDateTimeToUtcTimestamp(
            notification.INT_EventTime__c,
            'tidspunkt',
            true
        );
        beskjed.synligFremTil = UserNotification_BuilderValidationUtil.localDateTimeToUtcTimestamp(
            notification.INT_VisibleUntil__c,
            'synligFremTil',
            false
        );
        beskjed.fodselsnummer = UserNotification_BuilderValidationUtil.validateFodselsnummer(
            notification.INT_SocialSecurityNumber__c
        );
        beskjed.grupperingsId = UserNotification_BuilderValidationUtil.validateNonNullFieldMaxLength(
            notification.INT_GroupingId__c,
            'grupperingsId',
            100
        );
        beskjed.tekst = UserNotification_BuilderValidationUtil.validateNonNullFieldMaxLength(
            notification.INT_Description__c,
            'tekst',
            500
        );
        beskjed.link = UserNotification_BuilderValidationUtil.validateLinkAndConvertToString(
            notification.INT_Link__c,
            'link',
            200,
            false
        );
        beskjed.sikkerhetsnivaa = UserNotification_BuilderValidationUtil.validateSikkerhetsnivaa(
            notification.INT_SecurityLevel__c.IntValue()
        );
        beskjed.eksternVarsling = notification.INT_ExternalNotification__c;
        beskjed.prefererteKanaler = UserNotification_BuilderValidationUtil.validatePrefererteKanaler(
            notification.INT_ExternalNotification__c,
            UserNotification_Util.multiSelectToList(notification.INT_PreferredChannel__c)
        );

        return beskjed;
    }
}
