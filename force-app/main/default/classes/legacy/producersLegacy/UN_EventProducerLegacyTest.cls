@IsTest
private with sharing class UN_EventProducerLegacyTest {
    @IsTest
    static void testMessages() {
        UN_EventProducerLegacy ep;

        Test.startTest();
        ep = new UN_EventProducerLegacy('testSfUser', 'test-topic');
        ep.produceEvents(
            new List<UN_EventProducerLegacy.KafkaMessage>{ new UN_EventProducerLegacy.KafkaMessage('key', 'value') }
        );
        ep.publishEvent();
        Test.stopTest();

        System.assertEquals('testSfUser', ep.event.systemUser, 'Expected value to be set');
        System.assertEquals('test-topic', ep.event.topic, 'Expected value to be set');
        System.assertEquals(1, ep.event.messages.size(), 'Expected value to be set');
        System.assertEquals('key', ep.event.messages[0].key, 'Expected value to be set');
        System.assertEquals('value', ep.event.messages[0].value, 'Expected value to be set');
    }

    @IsTest
    static void testObjMap() {
        UN_EventProducerLegacy ep;

        Test.startTest();
        ep = new UN_EventProducerLegacy('testSfUser', 'test-topic');
        ep.produceEvents(new Map<Object, Object>{ 'test' => 'test' });
        ep.publishEvent();
        Test.stopTest();

        System.assertEquals('testSfUser', ep.event.systemUser, 'Expected value to be set');
        System.assertEquals('test-topic', ep.event.topic, 'Expected value to be set');
        System.assertEquals(1, ep.event.messages.size(), 'Expected value to be set');
        System.assertEquals('key', ep.event.messages[0].key, 'Expected value to be set');
        System.assertEquals('value', ep.event.messages[0].value, 'Expected value to be set');
    }

    @IsTest
    static void testObjList() {
        UN_EventProducerLegacy ep;

        Test.startTest();
        ep = new UN_EventProducerLegacy('testSfUser', 'test-topic');
        ep.produceEvents(new List<Object>{ 'test' });
        ep.publishEvent();
        Test.stopTest();

        System.assertEquals('testSfUser', ep.event.systemUser, 'Expected value to be set');
        System.assertEquals('test-topic', ep.event.topic, 'Expected value to be set');
        System.assertEquals(1, ep.event.messages.size(), 'Expected value to be set');
        System.assertEquals('key', ep.event.messages[0].key, 'Expected value to be set');
        System.assertEquals('value', ep.event.messages[0].value, 'Expected value to be set');
    }
}
