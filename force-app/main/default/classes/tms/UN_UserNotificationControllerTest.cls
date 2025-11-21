@isTest
private class UN_UserNotificationControllerTest {
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

    @isTest
    static void testPublishInnboksEvents_success() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'Success');
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];
        UserNotification__c un = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test notification',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = new Uuid().getValue(),
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            INT_Key__c = 'sfbrukernotifikasjonteamcrmevent123'
        );
        insert un;

        List<UserNotification__c> notifications = new List<UserNotification__c>{ un };

        Test.startTest();
        List<UserNotification__c> result = UN_UserNotificationController.publishInnboksEvents(notifications, false);
        Test.stopTest();

        result = [
            SELECT Id, CRM_SuccessfullySentNotification__c, CRM_NotificationError__c
            FROM UserNotification__c
            WHERE Id = :un.Id
        ];
        Assert.areEqual(1, result.size());
        Assert.areEqual(
            true,
            result[0].CRM_SuccessfullySentNotification__c,
            'Expected successfully sent, but got error: ' + result[0].CRM_NotificationError__c
        );
        Assert.areEqual(null, result[0].CRM_NotificationError__c);
    }

    @isTest
    static void testPublishInnboksEvents_errorOnHttp() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 500, 'Some error');
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];
        UserNotification__c un = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test notification with error',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = new Uuid().getValue(),
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            INT_Key__c = 'sfbrukernotifikasjonteamcrmevent456'
        );
        insert un;

        List<UserNotification__c> notifications = new List<UserNotification__c>{ un };

        Test.startTest();
        List<UserNotification__c> result = UN_UserNotificationController.publishInnboksEvents(notifications, false);
        Test.stopTest();

        result = [
            SELECT Id, CRM_SuccessfullySentNotification__c, CRM_NotificationError__c
            FROM UserNotification__c
            WHERE Id = :un.Id
        ];
        Assert.areEqual(1, result.size());
        Assert.areEqual(false, result[0].CRM_SuccessfullySentNotification__c);
        Assert.isTrue(
            result[0].CRM_NotificationError__c != null &&
            result[0].CRM_NotificationError__c.contains('Could not publish user notifications')
        );
    }

    @isTest
    static void testPublishInnboksEvents_UpsertFailure() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'OK');
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];

        UserNotification__c un = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test for upsert error',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = 'DUPLICATEKEY',
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            INT_Key__c = 'sfbrukernotifikasjonteamcrmeventDUP'
        );
        insert un;

        UserNotification__c duplicateUn = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test for upsert error',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = 'DUPLICATEKEY',
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            INT_Key__c = 'sfbrukernotifikasjonteamcrmeventDUP'
        );

        List<UserNotification__c> notifications = new List<UserNotification__c>{ un, duplicateUn };

        Test.startTest();
        List<UserNotification__c> result = UN_UserNotificationController.publishInnboksEvents(notifications, false);
        Test.stopTest();

        Boolean foundUpsertError = false;
        for (UserNotification__c notif : result) {
            if (notif.CRM_NotificationError__c != null && notif.CRM_NotificationError__c.contains('[upsert-failed]:')) {
                foundUpsertError = true;
            }
        }
        Assert.isTrue(foundUpsertError);
    }
}
