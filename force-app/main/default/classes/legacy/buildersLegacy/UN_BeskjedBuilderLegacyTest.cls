@IsTest
private with sharing class UN_BeskjedBuilderLegacyTest {
    @IsTest
    static void testBuild() {
        UserNotification__c notification = new UserNotification__c();
        notification.INT_EventTime__c = Datetime.now();
        notification.INT_VisibleUntil__c = Datetime.now();
        notification.INT_SocialSecurityNumber__c = '12345678901';
        notification.INT_GroupingId__c = '12345Group';
        notification.INT_Description__c = 'Test description';
        notification.INT_Link__c = 'https://nav.no';
        notification.INT_SecurityLevel__c = 4;
        notification.INT_ExternalNotification__c = true;
        notification.INT_PreferredChannel__c = 'SMS;EPOST';

        UN_BeskjedLegacy result;

        Test.startTest();
        result = new UN_BeskjedBuilderLegacy(notification).build();
        Test.stopTest();

        System.assertEquals(
            notification.INT_SocialSecurityNumber__c,
            result.fodselsnummer,
            'Expected the value to be set correctly'
        );
        System.assertEquals(
            notification.INT_GroupingId__c,
            result.grupperingsId,
            'Expected the value to be set correctly'
        );
        System.assertEquals(notification.INT_Description__c, result.tekst, 'Expected the value to be set correctly');
        System.assertEquals(notification.INT_Link__c, result.link, 'Expected the value to be set correctly');
        System.assertEquals(4, result.sikkerhetsnivaa, 'Expected the value to be set correctly');
        System.assertEquals(
            notification.INT_ExternalNotification__c,
            result.eksternVarsling,
            'Expected the value to be set correctly'
        );
        // System.assertEquals(2, result.prefererteKanaler.size(), 'Expected the value to be set correctly');
    }
}
