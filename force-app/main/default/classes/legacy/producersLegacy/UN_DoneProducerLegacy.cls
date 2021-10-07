public with sharing class UN_DoneProducerLegacy {
    @InvocableMethod(
        label='Create Done Notification'
        description='Create an done notification that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> produceDoneNotification(List<Input> inputList) {
        List<UN_EventProducer> producerList = new List<UN_EventProducer>();

        for (Input input : inputList) {
            UN_NokkelLegacy nokkel = new UN_NokkelBuilderLegacy()
                .withEventId(input.userNotification.INT_EventId__c)
                .withSystembruker(input.userNotification.INT_SystemUser__c)
                .build();
            UN_DoneLegacy done = new UN_DoneBuilderLegacy()
                .withFodselsnummer(input.userNotification.INT_SocialSecurityNumber__c)
                .withGrupperingsId(input.userNotification.INT_GroupingId__c)
                .withTidspunkt(input.tidspunkt)
                .build();

            producerList.add(new UN_EventProducer(UN_EventType.DONE).setKey(nokkel).setValue(done));
        }

        return UN_EventProducer.publish(producerList);
    }

    public class Input {
        @InvocableVariable(label='Tidspunkt' required=true)
        public Datetime tidspunkt;
        @InvocableVariable(label='User Notification' required=false)
        public UserNotification__c userNotification;
    }
}
