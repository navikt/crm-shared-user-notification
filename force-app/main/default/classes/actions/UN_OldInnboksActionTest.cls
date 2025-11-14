@IsTest
public with sharing class UN_OldInnboksActionTest {
    @TestSetup
    static void makeData() {
        Person__c person = (Person__c) UN_TestDataFactory.createRecord(
            new Person__c(
                Name = '12345678901',
                INT_ActorId__c = '9876543210',
                INT_LastName__c = 'LastName',
                INT_FirstName__c = 'FirstName'
            ),
            true
        );
    }

    @IsTest
    static void runInnboksAction() {
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];
        List<UN_OldInnboksAction.Input> inputList = new List<UN_OldInnboksAction.Input>();

        inputList.add(new UN_OldInnboksAction.Input());
        inputList[0].accountId = p.CRM_Account__c;
        inputList[0].appnavn = 'sf-brukernotifikasjoner';
        inputList[0].eksternVarsling = true;
        inputList[0].epostVarslingstekst = 'epostVarslingstekst';
        inputList[0].epostVarslingsttittel = 'epostVarslingsttittel';
        inputList[0].eventId = null;
        inputList[0].fodselsnummer = p.Name;
        inputList[0].grupperingsId = '1234';
        inputList[0].link = 'https://nav.no';
        inputList[0].namespace = 'teamcrm';
        inputList[0].prefererteKanaler = 'SMS,EPOST';
        inputList[0].relatedRecordSfId = p.CRM_Account__c;
        inputList[0].sikkerhetsnivaa = 4;
        inputList[0].smsVarslingstekst = 'smsVarslingstekst';
        inputList[0].tekst = 'tekst';
        inputList[0].tidspunkt = Datetime.now();

        List<UN_OldInnboksAction.Response> insertResponses;

        Test.startTest();
        insertResponses = UN_OldInnboksAction.produceInnboksNotification(inputList);
        Test.stopTest();

        System.assertEquals(1, insertResponses.size(), 'Expected a response');
        System.assertEquals(
            true,
            insertResponses[0].success,
            'Expected sucess, but got error. Error message: ' + insertResponses[0].errorMessage
        );

        List<UserNotification__c> notifications = UN_Util.getUserNotifications(
            new Set<Id>{ insertResponses[0].userNotification.Id }
        );
        System.assertEquals(1, notifications.size(), 'Expected a usernotification');
        System.assertEquals(
            true,
            String.isBlank(notifications[0].CRM_NotificationError__c),
            'Expected blank, not ' + notifications[0].CRM_NotificationError__c
        );
    }
}
