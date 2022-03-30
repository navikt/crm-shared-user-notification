public without sharing class UN_DoneProducerLegacy {
    @InvocableMethod(
        label='Create Done Notification'
        description='Create an done notification that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> produceDoneNotification(List<Input> legacyInputList) {
        List<UserNotification__c> response = new List<UserNotification__c>();
        List<UN_DoneAction.Input> inputList = new List<UN_DoneAction.Input>();
        for (Input legacyInput : legacyInputList) {
            UN_DoneAction.Input input = new UN_DoneAction.Input();
            input.tidspunkt = legacyInput.tidspunkt;
            input.userNotification = legacyInput.userNotification;
            inputList.add(input);
        }

        for (UN_DoneAction.Response resp : UN_DoneAction.produceDoneNotifications(inputList)) {
            response.add(resp.userNotification);
        }

        return response;
    }

    public class Input {
        @InvocableVariable(label='Tidspunkt' required=true)
        public Datetime tidspunkt;
        @InvocableVariable(label='User Notification' required=false)
        public UserNotification__c userNotification;
    }
}
