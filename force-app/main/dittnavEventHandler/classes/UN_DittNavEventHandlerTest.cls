@IsTest
private with sharing class UN_DittNavEventHandlerTest {
    @IsTest
    private static void getAllEventsAuraTest() {
        ApiMock.setTestMock('DITTNAV_EVENT_FETCH', 200, 'OK');

        List<UN_DittNavEvent> result;
        Test.startTest();
        result = UN_DittNavEventHandler.getAllEventsAura('123456789');
        Test.stopTest();

        System.assertEquals(false, result.isEmpty(), 'Expected to get some results');
    }
}
