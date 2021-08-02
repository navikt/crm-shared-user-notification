public with sharing class UserNotification_DoneKafkaHandler extends UserNotification_KafkaHandler {
    protected override void buildNotification(String decodedValue, UserNotification__c notification) {
        UserNotification_Done done = (UserNotification_Done) JSON.deserialize(
            decodedValue,
            UserNotification_Done.class
        );

        notification.CRM_Done__c = true;
        notification.INT_DoneEventTime__c = UserNotification_Util.longTimeToDateTime(done.tidspunkt);
        notification.INT_SocialSecurityNumber__c = done.fodselsnummer;
    }
}
