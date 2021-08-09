public with sharing class UserNotification_NokkelBuilder {
    public static UserNotification_Nokkel build(UserNotification__c notification) {
        UserNotification_Nokkel nokkel = new UserNotification_Nokkel();
        nokkel.systembruker = UserNotification_BuilderValidationUtil.validateNonNullFieldMaxLength(
            notification.INT_SystemUser__c,
            'systembruker',
            UserNotification_BuilderValidationUtil.MAX_LENGTH_SYSTEMBRUKER
        );
        nokkel.eventId = UserNotification_BuilderValidationUtil.validateNonNullFieldMaxLength(
            notification.INT_EventId__c,
            'eventId',
            UserNotification_BuilderValidationUtil.MAX_LENGTH_EVENTID
        );
        return nokkel;
    }
}
