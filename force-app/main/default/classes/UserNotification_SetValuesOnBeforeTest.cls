@IsTest
private with sharing class UserNotification_SetValuesOnBeforeTest {
    @TestSetup
    static void makeData() {
        Person__c p = (Person__c) UserNotification_TestDataFactory.createRecord(
            new Person__c(
                Name = '12345678901',
                INT_LastName__c = 'Potter',
                INT_IsNavEmployee__c = false,
                INT_Confidential__c = 'UGRADERT',
                INT_MunicipalityNumber__c = '1234'
            )
        );
    }

    @IsTest
    static void createUserNotification() {
        Account acc = [SELECT Id, CRM_Person__r.Name FROM Account LIMIT 1];
        UserNotification__c notification = new UserNotification__c(
            INT_EventTime__c = Datetime.now(),
            INT_VisibleUntil__c = Datetime.now(),
            INT_GroupingId__c = '12345Group',
            INT_Description__c = 'Test description',
            INT_Link__c = 'https://nav.no',
            INT_SecurityLevel__c = 4,
            INT_ExternalNotification__c = true,
            INT_PreferredChannel__c = 'SMS;EPOST',
            INT_SystemUser__c = 'teamnks',
            CRM_Account__c = acc.Id
        );

        UserNotification_Util.setEventId(notification);
        UserNotification_Util.setKey(notification);

        Test.startTest();
        insert notification;
        Test.stopTest();

        System.assertNotEquals(null, notification.Id, 'Expected this to be set.');

        notification = [
            SELECT Id, INT_SocialSecurityNumber__c, INT_EventId__c, INT_Key__c
            FROM UserNotification__c
            WHERE Id = :notification.Id
        ];

        System.assertEquals('12345678901', notification.INT_SocialSecurityNumber__c, 'Expected this to be set.');
        System.assertEquals(true, String.isNotBlank(notification.INT_EventId__c), 'Expected this to be set.');
        System.assertEquals(true, String.isNotBlank(notification.INT_Key__c), 'Expected this to be set.');
    }
}
