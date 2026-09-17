@IsTest
private with sharing class UN_RepublishUsernotificationBatchTest {
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
    static void testResendUnreadNotification() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'OK');
        Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];

        UserNotification__c un = new UserNotification__c();
        un.INT_SocialSecurityNumber__c = '12345678901';
        un.INT_Link__c = 'https://www.nav.no';
        un.INT_Preferred_Channel__c = 'SMS';
        un.INT_Sensitivity__c = 'high';
        un.INT_Description__c = 'Test Message';
        un.CRM_NotificationError__c = 'Error Message';
        un.INT_EventId__c = '1231-123123-1312213';
        un.INT_Key__c = un.INT_EventId__c;
        un.CRM_Account__c = acc.Id;
        un.INT_Type__c = 'INNBOKS';
        insert un;

        Test.startTest();
        new UN_RepublishUsernotificationBatch()
            .setFilter(
                'INT_Type__c =\'INNBOKS\' AND INT_Preferred_Channel__c != null AND CRM_NotificationError__c != null'
            )
            .run();
        Test.stopTest();

        un = [SELECT Id, CRM_NotificationError__c FROM UserNotification__c WHERE Id = :un.Id LIMIT 1];

        Assert.areEqual(true, String.isBlank(un.CRM_NotificationError__c), 'Expected error message to be null');
    }

    @IsTest
    static void testResendUnreadNotificationError() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 401, 'ERROR');
        Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];

        UserNotification__c un = new UserNotification__c();
        un.INT_SocialSecurityNumber__c = '12345678901';
        un.INT_Link__c = 'https://www.nav.no';
        un.INT_Preferred_Channel__c = 'SMS';
        un.INT_Sensitivity__c = 'high';
        un.INT_Description__c = 'Test Message';
        un.CRM_NotificationError__c = 'Error Message';
        un.INT_EventId__c = '1231-123123-1312213';
        un.INT_Key__c = un.INT_EventId__c;
        un.CRM_Account__c = acc.Id;
        un.INT_Type__c = 'INNBOKS';
        insert un;

        Test.startTest();
        new UN_RepublishUsernotificationBatch()
            .setFilter(
                'INT_Type__c =\'INNBOKS\' AND INT_Preferred_Channel__c != null AND CRM_NotificationError__c != null'
            )
            .run();
        Test.stopTest();

        un = [SELECT Id, CRM_NotificationError__c FROM UserNotification__c WHERE Id = :un.Id LIMIT 1];

        Assert.areEqual(true, String.isNotBlank(un.CRM_NotificationError__c), 'Expected error message to NOT be null');
    }

    @IsTest
    static void testResendReadNotificationSendMessage() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'OK');
        Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];

        UserNotification__c un = new UserNotification__c();
        un.INT_SocialSecurityNumber__c = '12345678901';
        un.INT_Link__c = 'https://www.nav.no';
        un.INT_Preferred_Channel__c = 'SMS';
        un.INT_Sensitivity__c = 'high';
        un.INT_Description__c = 'Test Message';
        un.CRM_NotificationError__c = 'Error Message';
        un.INT_EventId__c = '1231-123123-1312213';
        un.INT_Key__c = un.INT_EventId__c;
        un.CRM_Account__c = acc.Id;
        un.INT_Type__c = 'INNBOKS';
        un.CRM_Done__c = true;
        insert un;

        Test.startTest();
        new UN_RepublishUsernotificationBatch()
            .setIsDoneNotifications()
            .setFilter('INT_Type__c =\'INNBOKS\' AND INT_Preferred_Channel__c != null AND CRM_NotificationError__c != null')
            .setBatchSize(2)
            .run();
        Test.stopTest();

        un = [
            SELECT Id, CRM_NotificationError__c, INT_Preferred_Channel__c
            FROM UserNotification__c
            WHERE Id = :un.Id
            LIMIT 1
        ];

        Assert.areEqual(true, String.isBlank(un.CRM_NotificationError__c), 'Expected error message to be null');
        Assert.areEqual(false, String.isBlank(un.INT_Preferred_Channel__c), 'Expected preferred channel');
    }

    @IsTest
    static void testResendReadNotificationSendDoneMessage() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'OK');
        Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];

        UserNotification__c un = new UserNotification__c();
        un.INT_SocialSecurityNumber__c = '12345678901';
        un.INT_Link__c = 'https://www.nav.no';
        un.INT_Preferred_Channel__c = 'SMS';
        un.INT_Sensitivity__c = 'high';
        un.INT_Description__c = 'Test Message';
        un.CRM_NotificationError__c = 'Error Message';
        un.INT_EventId__c = '1231-123123-1312213';
        un.INT_Key__c = un.INT_EventId__c;
        un.CRM_Account__c = acc.Id;
        un.INT_Type__c = 'INNBOKS';
        un.CRM_Done__c = true;
        insert un;

        Test.startTest();
        new UN_RepublishUsernotificationBatch()
            .setIsDoneNotifications()
            .setFilter('INT_Type__c =\'INNBOKS\' AND INT_Preferred_Channel__c != null AND CRM_NotificationError__c != null')
            .setBatchSize(2)
            .run();
        Test.stopTest();

        un = [
            SELECT Id, CRM_NotificationError__c, INT_Preferred_Channel__c
            FROM UserNotification__c
            WHERE Id = :un.Id
            LIMIT 1
        ];

        Assert.areEqual(true, String.isBlank(un.CRM_NotificationError__c), 'Expected error message to be null');
        Assert.areEqual(false, String.isBlank(un.INT_Preferred_Channel__c), 'Expected preferred channel to not be removed');
    }

    @IsTest
    static void testResendReadNotificationSendDoneMessageError() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 401, 'Error');
        Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];

        UserNotification__c un = new UserNotification__c();
        un.INT_SocialSecurityNumber__c = '12345678901';
        un.INT_Link__c = 'https://www.nav.no';
        un.INT_Preferred_Channel__c = 'SMS';
        un.INT_Sensitivity__c = 'high';
        un.INT_Description__c = 'Test Message';
        un.CRM_NotificationError__c = 'Error Message';
        un.INT_EventId__c = '1231-123123-1312213';
        un.INT_Key__c = un.INT_EventId__c;
        un.CRM_Account__c = acc.Id;
        un.INT_Type__c = 'INNBOKS';
        un.CRM_Done__c = true;
        insert un;

        Test.startTest();
        new UN_RepublishUsernotificationBatch()
            .setIsDoneNotifications()
            .setFilter('INT_Type__c =\'INNBOKS\' AND INT_Preferred_Channel__c != null AND CRM_NotificationError__c != null')
            .setBatchSize(2)
            .run();
        Test.stopTest();

        un = [
            SELECT Id, CRM_NotificationError__c, INT_Preferred_Channel__c
            FROM UserNotification__c
            WHERE Id = :un.Id
            LIMIT 1
        ];

        Assert.areEqual(true, String.isNotBlank(un.CRM_NotificationError__c), 'Expected error message to NOT be null');
    }
}