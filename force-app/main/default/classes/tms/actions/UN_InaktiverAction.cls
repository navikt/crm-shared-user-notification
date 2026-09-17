public without sharing class UN_InaktiverAction {
    @InvocableMethod(
        label='Create Inaktiver Event'
        description='Create an Innaktiver event that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<Response> produceInaktiverEvents(List<Input> inputList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        Map<String, Response> responseMap = new Map<String, Response>();
        Map<Integer, String> indexToKey = new Map<Integer, String>();

        Integer inputIndex = 0;
        for (Input input : inputList) {
            Response resp = new Response();
            resp.success = false;
            if (input == null || input.userNotification == null) {
                resp.errorMessage = 'Input or UserNotification is null';
                responseMap.put(String.valueOf(inputIndex), resp);
                inputIndex++;
                continue;
            }
            try {
                String varselId = input.userNotification.INT_EventId__c;
                UN_EventMapper.mapUserNotificationToInaktiverEvent(
                    new UN_InaktiverEvent(varselId),
                    input.userNotification
                );
                userNotifications.add(input.userNotification);

                resp.relatedRecordSfId = input.userNotification.CRM_RelatedSfRecord__c;
                resp.userNotification = input.userNotification;
                resp.success = null;
                responseMap.put(varselId, resp);
                indexToKey.put(userNotifications.size() - 1, varselId);
            } catch (Exception e) {
                resp.errorMessage = e.getMessage();
                resp.relatedRecordSfId = (input.userNotification != null)
                    ? input.userNotification.CRM_RelatedSfRecord__c
                    : null;
                resp.userNotification = input.userNotification;
                responseMap.put(input.userNotification.INT_EventId__c, resp);
            }
            inputIndex++;
        }

        Integer index = 0;
        for (Database.SaveResult sr : Database.update(userNotifications, false)) {
            String key = indexToKey.get(index);
            if (responseMap.containsKey(key)) {
                Response resp = responseMap.get(key);
                if (sr.isSuccess()) {
                    resp.success = true;
                    resp.errorMessage = null;
                } else {
                    resp.success = false;
                    List<String> errors = new List<String>();
                    for (Database.Error err : sr.getErrors()) {
                        errors.add(err.getMessage());
                    }
                    resp.errorMessage = String.join(errors, '; ');
                }
                resp.userNotification = userNotifications[index];
            }
            index++;
        }

        List<Response> results = new List<Response>();
        for (String key : responseMap.keySet()) {
            results.add(responseMap.get(key));
        }
        return results;
    }

    public class Input {
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
