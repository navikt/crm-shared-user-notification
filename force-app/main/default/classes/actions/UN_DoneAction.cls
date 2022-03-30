public with sharing class UN_DoneAction {
    @InvocableMethod(
        label='Create Done Notification'
        description='Create an done notification that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<Response> produceDoneNotifications(List<Input> inputList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        Map<String, Response> responseMap = new Map<String, Response>();

        for (Input input : inputList) {
            Response resp = new Response();
            try {
                UN_NokkelInput nokkel = UN_NokkelMapper.userNotificationToNokkelInput(input.userNotification);
                UN_DoneMapper.doneInputToUserNotification(
                    new UN_DoneInputBuilder().withTidspunkt(input.tidspunkt).build(),
                    input.userNotification
                );
                userNotifications.add(input.userNotification);

                resp.relatedRecordSfId = input.userNotification.CRM_RelatedSfRecord__c;
                resp.userNotification = input.userNotification;
                responseMap.put(nokkel.eventId, resp);
            } catch (Exception e) {
                resp.errorMessage = e.getMessage();
                resp.relatedRecordSfId = input.userNotification.CRM_RelatedSfRecord__c;
                resp.success = false;
                responseMap.put(resp.relatedRecordSfId, resp);
            }
        }

        Integer index = 0;
        for (Database.SaveResult sr : Database.update(userNotifications, false)) {
            String key = UN_NokkelMapper.userNotificationToNokkelInput(userNotifications[index]).eventId;
            if (sr.isSuccess()) {
                responseMap.get(key).success = true;
            } else {
                responseMap.get(key).success = false;
                responseMap.get(key).errorMessage = sr.getErrors()[0].getMessage();
            }
            index++;
        }

        return responseMap.values();
    }

    public class Input {
        @InvocableVariable(label='Tidspunkt' required=true)
        public Datetime tidspunkt;
        @InvocableVariable(label='User Notification' required=false)
        public UserNotification__c userNotification;
    }

    public class Response {
        @InvocableVariable(label='User Notification')
        public UserNotification__c userNotification;
        @InvocableVariable(label='Related Record Id' required=false)
        public String relatedRecordSfId;
        @InvocableVariable(label='Success')
        public Boolean success;
        @InvocableVariable(label='Error Message')
        public String errorMessage;
    }
}
