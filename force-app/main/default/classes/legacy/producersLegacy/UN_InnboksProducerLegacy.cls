public with sharing class UN_InnboksProducerLegacy {
    @InvocableMethod(
        label='Create Innboks Notification'
        description='Create an innboks notification that appears on Nav.no. See https://navikt.github.io/dittnav-brukernotifikasjoner-intro/ for details'
        category='User Notification'
    )
    public static List<UserNotification__c> produceInnboksNotification(List<Input> inputList) {
        List<UN_EventProducer> producerList = new List<UN_EventProducer>();
        for (Input input : inputList) {
            UN_NokkelLegacy nokkel = new UN_NokkelBuilderLegacy()
                .withEventId(String.isBlank(input.eventId) ? new Uuid().getValue() : input.eventId)
                .withSystembruker(input.systembruker)
                .build();
            UN_InnboksLegacy innboks = new UN_InnboksBuilderLegacy()
                .withFodselsnummer(input.fodselsnummer)
                .withGrupperingsId(input.grupperingsId)
                .withLink(input.link)
                .withSikkerhetsnivaa(input.sikkerhetsnivaa)
                .withTekst(input.tekst)
                .withTidspunkt(input.tidspunkt)
                .withEksternVarsling(input.eksternVarsling)
                .withPrefererteKanaler(input.prefererteKanaler)
                .build();

            producerList.add(
                new UN_EventProducer(UN_EventType.INNBOKS)
                    .setKey(nokkel)
                    .setValue(innboks)
                    .setAccountId(input.accountId)
                    .setRelatedSfRecord(input.relatedRecordSfId)
                    .setSystemContext()
            );
        }

        return UN_EventProducer.publish(producerList);
    }

    public class Input {
        @InvocableVariable(label='Tidspunkt' required=true)
        public Datetime tidspunkt;
        @InvocableVariable(label='Fodselsnummer' required=true)
        public String fodselsnummer;
        @InvocableVariable(label='Grupperings Id' required=true)
        public String grupperingsId;
        @InvocableVariable(label='Tekst' required=true)
        public String tekst;
        @InvocableVariable(label='Link' required=false)
        public String link;
        @InvocableVariable(label='Sikkerhetsnivå' required=false)
        public Integer sikkerhetsnivaa;
        @InvocableVariable(label='Systembruker' required=true)
        public String systembruker;
        @InvocableVariable(label='Related SF Record Id' required=false)
        public String relatedRecordSfId;
        @InvocableVariable(label='Event Id' required=false)
        public String eventId;
        @InvocableVariable(label='Account Id' required=true)
        public String accountId;
        @InvocableVariable(label='Prefererte kanaler' required=false)
        public String prefererteKanaler;
        @InvocableVariable(label='Ekstern varsling' required=false)
        public Boolean eksternVarsling;
    }
}
