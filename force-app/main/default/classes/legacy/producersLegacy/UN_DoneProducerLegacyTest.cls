@IsTest
private with sharing class UN_DoneProducerLegacyTest {
    @IsTest
    static void test() {
        Person__c person = (Person__c) UN_TestDataFactory.createRecord(
            new Person__c(
                Name = '12345678901',
                INT_ActorId__c = '9876543210',
                INT_LastName__c = 'LastName',
                INT_FirstName__c = 'FirstName'
            ),
            true
        );

        Account acc = [SELECT Id FROM Account WHERE CRM_Person__c = :person.Id];

        ApiMock.setTestMock('POST_INNBOKS_EVENT', 200, 'OK');

        UN_InnboksProducerLegacy.Input input = new UN_InnboksProducerLegacy.Input();
        input.tidspunkt = DateTime.now();
        input.fodselsnummer = '12345678901';
        input.grupperingsId = '982340sdjfskjdf';
        input.tekst = 'Test tetest';
        input.link = 'https://nav.no';
        input.sikkerhetsnivaa = 4;
        input.systembruker = 'testTest';
        input.relatedRecordSfId = null;
        input.eventId = null;
        input.accountId = acc.Id;
        input.prefererteKanaler = 'SMS,EPOST';
        input.eksternVarsling = true;

        List<UserNotification__c> result;

        result = UN_InnboksProducerLegacy.produceInnboksNotification(new List<UN_InnboksProducerLegacy.Input>{ input });

        UN_DoneProducerLegacy.Input done = new UN_DoneProducerLegacy.Input();
        done.tidspunkt = Datetime.now();
        done.userNotification = result[0];

        Test.startTest();
        result = UN_DoneProducerLegacy.produceDoneNotification(new List<UN_DoneProducerLegacy.Input>{ done });
        Test.stopTest();
    }
}
