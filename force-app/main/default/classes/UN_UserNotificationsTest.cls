@IsTest
private with sharing class UN_UserNotificationsTest {
    // @TestSetup
    // static void makeData() {
    //     Person__c person = (Person__c) UN_TestDataFactory.createRecord(
    //         new Person__c(
    //             Name = '12345678901',
    //             INT_ActorId__c = '9876543210',
    //             INT_LastName__c = 'LastName',
    //             INT_FirstName__c = 'FirstName'
    //         ),
    //         true
    //     );
    // }

    // @IsTest
    // static void testResendInnboksNotification() {
    //     Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];
    //     UserNotification__c un = new UserNotification__c();
    //     un.INT_ExternalNotification__c = true;
    //     un.INT_SocialSecurityNumber__c = '12345678901';
    //     un.INT_GroupingId__c = '12345';
    //     un.INT_Link__c = 'https://www.nav.no';
    //     un.INT_PreferredChannel__c = 'SMS';
    //     un.INT_SecurityLevel__c = 4;
    //     un.INT_Description__c = 'Test test test';
    //     un.INT_EventTime__c = Datetime.now().addDays(-1);
    //     un.CRM_NotificationError__c = 'Error Error Error';
    //     un.INT_SystemUser__c = 'testUser';
    //     un.INT_EventId__c = '1231-123123-1312213';
    //     un.INT_Key__c = un.INT_SystemUser__c + un.INT_EventId__c;
    //     un.CRM_Account__c = acc.Id;
    //     un.INT_Type__c = 'INNBOKS';
    //     insert un;

    //     ApiMock.setTestMock('POST_INNBOKS_EVENT', 200, 'OK');

    //     Test.startTest();
    //     UN_UserNotifications.rePublishEventLegacy(un.Id, false);
    //     Test.stopTest();

    //     un = [SELECT Id, CRM_NotificationError__c FROM UserNotification__c WHERE Id = :un.Id LIMIT 1];

    //     System.assertEquals(true, String.isBlank(un.CRM_NotificationError__c), 'Expected error message to be null');
    // }

    // @IsTest
    // static void testResendDoneNotification() {
    //     Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210' LIMIT 1];

    //     UserNotification__c un = new UserNotification__c();
    //     un.INT_ExternalNotification__c = true;
    //     un.INT_SocialSecurityNumber__c = '12345678901';
    //     un.INT_GroupingId__c = '12345';
    //     un.INT_Link__c = 'https://www.nav.no';
    //     un.INT_PreferredChannel__c = 'SMS';
    //     un.INT_SecurityLevel__c = 4;
    //     un.INT_Description__c = 'Test test test';
    //     un.INT_EventTime__c = Datetime.now().addDays(-1).addMinutes(-2);
    //     un.CRM_Done__c = true;
    //     un.INT_DoneEventTime__c = Datetime.now().addDays(-1);
    //     un.CRM_NotificationError__c = 'Error Error Error';
    //     un.INT_SystemUser__c = 'testUser';
    //     un.INT_EventId__c = '1231-123123-1312213';
    //     un.INT_Key__c = un.INT_SystemUser__c + un.INT_EventId__c;
    //     un.CRM_Account__c = acc.Id;
    //     un.INT_Type__c = 'INNBOKS';

    //     insert un;

    //     ApiMock.setTestMock('POST_INNBOKS_EVENT', 200, 'OK');

    //     Test.startTest();
    //     UN_UserNotifications.rePublishEventLegacy(un.Id, true);
    //     Test.stopTest();

    //     un = [SELECT Id, CRM_NotificationError__c FROM UserNotification__c WHERE Id = :un.Id LIMIT 1];

    //     System.assertEquals(
    //         true,
    //         String.isBlank(un.CRM_NotificationError__c),
    //         'Expected notification error to be blank, but got ' + un.CRM_NotificationError__c
    //     );
    // }
}
