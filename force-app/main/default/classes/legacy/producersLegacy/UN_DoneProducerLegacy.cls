public with sharing class UN_DoneProducerLegacy {
    @InvocableMethod(
        label='Create Done Notification'
        description='Create an done notification that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> produceDoneNotification(List<Input> inputList) {
        //List<OutboundKafkaMessage__c> okmList = new List<OutboundKafkaMessage__c>();
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
            // okmList.add(
            //     new UN_EventProducer()
            //         .setKey(nokkel)
            //         .setValue(done)
            //         .setRelatedToSfId(input.relatedRecordSfId)
            //         .setTopic('DONE')
            //         .getOutboundMessage()
            // );
        }

        return UN_EventProducer.publish(producerList);

        //return okmList;
    }

    public class Input {
        // @InvocableVariable(label='Event Type' description='Possible values: BESKJED, OPPGAVE, INNBOKS' required=true)
        // public String type;
        // @InvocableVariable(label='Event Id' required=true)
        // public String eventId;
        @InvocableVariable(label='Tidspunkt' required=true)
        public Datetime tidspunkt;
        // @InvocableVariable(label='Fodselsnummer' required=true)
        // public String fodselsnummer;
        // @InvocableVariable(label='Grupperings Id' required=true)
        // public String grupperingsId;
        // @InvocableVariable(label='Systembruker' required=true)
        // public String systembruker;
        @InvocableVariable(label='User Notification' required=false)
        public UserNotification__c userNotification;
        // @InvocableVariable(label='Related SF Record Id' required=false)
        // public Id relatedRecordSfId;
    }
}
