@IsTest
private with sharing class UN_PublishInnboksNotificationActionTest {
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
    static void runPublishInnboksNotification() {
        ApiMock.setTestMock('UN_POST_INNBOKS_EVENTS', 200, 'OK');
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];

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
        UN_InnboksMapper.innboksInputToUserNotification(
            new UN_InnboksInputBuilder()
                .withEksternVarsling(true)
                .withTidspunkt(DateTime.now())
                .withTekst('test')
                .withSikkerhetsnivaa(4)
                .build(),
            un
        );

        insert un;

        Test.startTest();
        UN_PublishInnboksNotificationAction.publishInnboksNotification(
            UN_Util.getUserNotifications(new List<UserNotification__c>{ un })
        );
        Test.stopTest();

        List<UserNotification__c> notifications = UN_Util.getUserNotifications(new List<UserNotification__c>{ un });
        System.assertEquals(
            true,
            notifications[0].CRM_SuccessfullySentNotification__c,
            'Expected successfully sent, but got error: ' + notifications[0].CRM_NotificationError__c
        );
        System.assertEquals(
            false,
            notifications[0].CRM_SuccessfullySentDone__c,
            'Expected successfully sent done to be false'
        );
    }
}
