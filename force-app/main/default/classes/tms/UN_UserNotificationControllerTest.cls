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
            result[0].CRM_NotificationError__c.contains('Could not publish Opprett Varsel events')
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

    @isTest
    static void testPublishInaktiverEvents_success() {
        ApiMock.setTestMock('UN_POST_INAKTIVER_VARSEL_EVENT', 200, 'OK');
        Person__c p = [SELECT Id, Name, CRM_Account__c FROM Person__c WHERE Name = '12345678901'];
        UserNotification__c un = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test for Inaktiver event',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = new Uuid().getValue(),
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            CRM_SuccessfullySentNotification__c = true,
            INT_Key__c = 'sfbrukernotifikasjonteamcrmeventINAKTIVER1'
        );
        insert un;

        List<UserNotification__c> notifications = new List<UserNotification__c>{ un };

        Test.startTest();
        List<UserNotification__c> result = UN_UserNotificationController.publishInaktiverEvents(notifications, false);
        Test.stopTest();

        UserNotification__c res = [
            SELECT CRM_SuccessfullySentDone__c, CRM_NotificationError__c
            FROM UserNotification__c
            WHERE Id = :un.Id
        ];
        Assert.areEqual(true, res.CRM_SuccessfullySentDone__c);
        Assert.isTrue(res.CRM_NotificationError__c == null || res.CRM_NotificationError__c == '');
    }

    @isTest
    static void testPublishInaktiverEvents_errorOnHttp() {
        ApiMock.setTestMock('UN_POST_INAKTIVER_VARSEL_EVENT', 500, 'Internal error');
        Person__c p = [SELECT Id, Name, CRM_Account__c FROM Person__c WHERE Name = '12345678901'];
        UserNotification__c un = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test inaktiver error',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = new Uuid().getValue(),
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            CRM_SuccessfullySentNotification__c = false,
            INT_Key__c = 'sfbrukernotifikasjonteamcrmeventINAKTIVER2'
        );
        insert un;

        List<UserNotification__c> notifications = new List<UserNotification__c>{ un };

        Test.startTest();
        List<UserNotification__c> result = UN_UserNotificationController.publishInaktiverEvents(notifications, false);
        Test.stopTest();

        UserNotification__c res = [
            SELECT CRM_SuccessfullySentDone__c, CRM_NotificationError__c
            FROM UserNotification__c
            WHERE Id = :un.Id
        ];
        System.assertEquals(false, res.CRM_SuccessfullySentDone__c);
        System.assertNotEquals(null, res.CRM_NotificationError__c);
    }

    @isTest
    static void testPublishInaktiverEvents_UpdateFailure() {
        ApiMock.setTestMock('UN_POST_INAKTIVER_VARSEL_EVENT', 200, 'OK');
        Person__c p = [SELECT Id, Name, CRM_Account__c FROM Person__c WHERE Name = '12345678901'];

        UserNotification__c un1 = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test update error 1',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = 'DUPINAKTIVEID1',
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            CRM_SuccessfullySentDone__c = false,
            INT_Key__c = 'sfbrukernotifikasjonteamcrmeventINAKTIVER3'
        );
        insert un1;

        UserNotification__c un2 = new UserNotification__c(
            CRM_Account__c = p.CRM_Account__c,
            INT_SocialSecurityNumber__c = p.Name,
            INT_Description__c = 'Test update error 2',
            INT_Sensitivity__c = 'high',
            INT_EventId__c = 'DUPINAKTIVEID2',
            INT_Namespace__c = 'teamcrm',
            INT_AppName__c = 'sf-brukernotifikasjon',
            CRM_SuccessfullySentDone__c = false,
            INT_Key__c = 'sfbrukernotifikasjonteamcrmeventINAKTIVER4'
        );

        List<UserNotification__c> notifications = new List<UserNotification__c>{ un1, un2 };

        Test.startTest();
        List<UserNotification__c> result = UN_UserNotificationController.publishInaktiverEvents(notifications, false);
        Test.stopTest();

        Boolean foundUpdateError = false;
        for (UserNotification__c notif : result) {
            if (notif.CRM_NotificationError__c != null && notif.CRM_NotificationError__c.contains('[update-failed]:')) {
                foundUpdateError = true;
            }
        }
        System.assert(foundUpdateError);
    }
}
