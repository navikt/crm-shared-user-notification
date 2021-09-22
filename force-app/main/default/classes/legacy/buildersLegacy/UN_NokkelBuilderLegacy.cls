public with sharing class UN_NokkelBuilderLegacy {
    private String systembruker;
    private String eventId;

    public UN_NokkelBuilderLegacy() {
    }
    public UN_NokkelBuilderLegacy(UserNotification__c notification) {
        this.systembruker = notification.INT_SystemUser__c;
        this.eventId = notification.INT_EventId__c;
    }

    public UN_NokkelBuilderLegacy withSystembruker(String systembruker) {
        this.systembruker = systembruker;
        return this;
    }

    public UN_NokkelBuilderLegacy withEventId(String eventId) {
        this.eventId = eventId;
        return this;
    }

    public UN_NokkelLegacy build() {
        UN_NokkelLegacy nokkel = new UN_NokkelLegacy();
        nokkel.systembruker = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.systembruker,
            'systembruker',
            UN_BuilderValidationUtil.MAX_LENGTH_SYSTEMBRUKER
        );
        nokkel.eventId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.eventId,
            'eventId',
            UN_BuilderValidationUtil.MAX_LENGTH_EVENTID
        );
        return nokkel;
    }
}
