@IsTest
private with sharing class UN_DoneActionTest {
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

        Datetime doneTime = Datetime.now();

        UserNotification__c un = new UserNotification__c();
        un.CRM_Account__c = p.CRM_Account__c;
        UN_NokkelMapper.nokkelInputToUserNotification(
            new UN_NokkelInputBuilder()
                .withAppnavn('test')
                .withEventId('123431234')
                .withFodselsnummer(p.name)
                .withGrupperingsId('32442')
                .withNamespace('test')
                .build(),
            un
        );
        UN_OldInnboksMapper.innboksInputToUserNotification(
            new UN_InnboksInputBuilder()
                .withEksternVarsling(true)
                .withTidspunkt(DateTime.now().addHours(-1))
                .withTekst('test')
                .withSikkerhetsnivaa(4)
                .build(),
            un
        );
        un.CRM_SuccessfullySentNotification__c = true;
        insert un;

        List<UN_DoneAction.Input> inputList = new List<UN_DoneAction.Input>();
        inputList.add(new UN_DoneAction.Input());
        inputList[0].tidspunkt = doneTime;
        inputList[0].userNotification = un;

        List<UN_DoneAction.Response> doneResponses;
        Test.startTest();
        doneResponses = UN_DoneAction.produceDoneNotifications(inputList);
        Test.stopTest();

        System.assertEquals(1, doneResponses.size(), 'Expected a response');
        System.assertEquals(
            true,
            doneResponses[0].success,
            'Expected sucess, but got error. Error message: ' + doneResponses[0].errorMessage
        );

        List<UserNotification__c> notifications = UN_Util.getUserNotifications(
            new Set<Id>{ doneResponses[0].userNotification.Id }
        );

        System.assertEquals(doneTime, notifications[0].INT_DoneEventTime__c, '');
        System.assertEquals(true, notifications[0].CRM_Done__c, 'Expected true');
        System.assertEquals(
            true,
            String.isBlank(notifications[0].CRM_NotificationError__c),
            'Expected blank, not ' + notifications[0].CRM_NotificationError__c
        );
    }
}
