@IsTest
private with sharing class UN_UsernotificationStatusControllerTest {
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

        Account acc = [SELECT Id FROM Account WHERE CRM_Person__r.INT_ActorId__c = '9876543210'];

        UserNotification__c un = new UserNotification__c();
        un.INT_ExternalNotification__c = true;
        un.INT_SocialSecurityNumber__c = '12345678901';
        un.INT_GroupingId__c = '12345';
        un.INT_Link__c = 'https://www.nav.no';
        un.INT_PreferredChannel__c = 'SMS';
        un.INT_SecurityLevel__c = 4;
        un.INT_Description__c = 'Test test test';
        un.INT_EventTime__c = Datetime.now().addDays(-1);
        un.CRM_NotificationError__c = 'Error Error Error';
        un.INT_SystemUser__c = 'testUser';
        un.INT_EventId__c = '1231-123123-1312213';
        un.INT_Key__c = un.INT_SystemUser__c + un.INT_EventId__c;
        un.CRM_Account__c = acc.Id;
        un.INT_Type__c = 'INNBOKS';
        un.CRM_Done__c = true;
        un.INT_DoneEventTime__c = Datetime.now().addDays(-1);
        insert un;
    }

    @IsTest
    static void testQueries() {
        Test.startTest();
        System.assertEquals(
            1,
            UN_UsernotificationStatusController.getAggregatedUnpublishedDoneNotifications(Date.today()).size(),
            'Expected one user notification'
        );
        System.assertEquals(
            1,
            UN_UsernotificationStatusController.getAggregatedUnpublishedNotifications(Date.today()).size(),
            'Expected one user notification'
        );
        UN_UsernotificationStatusController.republishDoneNotifications();
        UN_UsernotificationStatusController.republishUnsentNotifications();
        System.assertEquals(2, UN_UsernotificationStatusController.findRunningRepublishBatches().size(), 'Two batches');
        Test.stopTest();
    }
}
