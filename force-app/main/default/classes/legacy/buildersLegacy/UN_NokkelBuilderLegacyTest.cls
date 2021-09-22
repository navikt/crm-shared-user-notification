@IsTest
private with sharing class UN_NokkelBuilderLegacyTest {
    @IsTest
    static void testBuild() {
        UserNotification__c notification = new UserNotification__c();
        notification.INT_SystemUser__c = 'TestSystem';
        notification.INT_EventId__c = '1234';

        UN_NokkelLegacy result;

        Test.startTest();
        result = new UN_NokkelBuilderLegacy(notification).build();
        Test.stopTest();

        System.assertEquals(notification.INT_SystemUser__c, result.systembruker, 'Expected same value');
        System.assertEquals(notification.INT_EventId__c, result.eventId, 'Expected same value');
    }
}
