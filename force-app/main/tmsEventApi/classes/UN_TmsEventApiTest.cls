@IsTest
private with sharing class UN_TmsEventApiTest {
    @IsTest
    private static void getAllEventsAuraTest() {
        ApiMock.setTestMock('TMS_SERVICE_PATH', 200, 'OK');

        List<UN_TmsEventApiEvent> result;
        Test.startTest();
        result = UN_TmsEventApi.getAllEventsAura('123456789');
        Test.stopTest();

        System.assertEquals(false, result.isEmpty(), 'Expected to get some results');
        for (UN_TmsEventApiEvent e : result) {
            if (UN_TmsEventApi.PRODUCERS_TO_SKIP.contains(e.produsent)) {
                System.assertEquals(
                    false,
                    'Event is created by the producer ' +
                    e.produsent +
                    ' and should be filtered out.'
                );
            }
        }
    }
}
