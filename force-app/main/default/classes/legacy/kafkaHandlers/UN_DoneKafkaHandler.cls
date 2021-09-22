public with sharing class UN_DoneKafkaHandler extends UN_KafkaHandler {
    protected override void buildNotification(String decodedValue, UserNotification__c notification) {
        UN_DoneLegacy done = (UN_DoneLegacy) JSON.deserialize(decodedValue, UN_DoneLegacy.class);

        notification.CRM_Done__c = true;
        notification.INT_DoneEventTime__c = UN_Util.longTimeToDateTime(done.tidspunkt);
        notification.INT_SocialSecurityNumber__c = done.fodselsnummer;
    }
}
