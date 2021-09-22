@IsTest
private with sharing class UN_BeskjedProducerLegacyTest {
    @IsTest
    static void testProduceEvent() {
        UN_BeskjedProducerLegacy producer;
        List<UserNotification__c> notifications = new List<UserNotification__c>();

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
        notification.INT_SystemUser__c = 'TestSystem';
        notification.INT_EventId__c = '1234';

        notifications.add(notification);

        Test.startTest();
        producer = new UN_BeskjedProducerLegacy('testSfUser', 'test-topic');
        producer.produceEvents(notifications);
        producer.publishEvent();
        Test.stopTest();

        System.assertEquals('testSfUser', producer.event.systemUser, 'Expected value to be set');
        System.assertEquals('test-topic', producer.event.topic, 'Expected value to be set');
        System.assertEquals(1, producer.event.messages.size(), 'Expected value to be set');
        // System.assertEquals(
        //     JSON.serialize(UN_NokkelBuilderLegacy.build((UserNotification__c) notification), true),
        //     producer.event.messages[0].key,
        //     'Expected value to be set'
        // );
        // System.assertEquals(
        //     JSON.serialize(UN_BeskjedBuilderLegacy.build((UserNotification__c) notification), true),
        //     producer.event.messages[0].value,
        //     'Expected value to be set'
        // );
    }
}
