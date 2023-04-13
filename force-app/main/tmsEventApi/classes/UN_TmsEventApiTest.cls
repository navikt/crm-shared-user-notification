@IsTest
private with sharing class UN_TmsEventApiTest {

    public static void xyzzy(Object o) {
        System.debug('xyzzy ' + JSON.serializePretty(o));
    }

    /**
     * Ensure that the new EksternVarsling and EksternVarslingHistorikkEntry
     * objects are picked up.
     */
    @IsTest
    private static void getEventWithExternalNotification() {
        ApiMock.setTestMock('TMS_SERVICE_PATH', 200, 'OK');
        List<UN_TmsEventApiEvent> result;
        Test.startTest();
        result = UN_TmsEventApi.getAllEventsAura('123456789');
        xyzzy(result);
        Test.stopTest();
        System.assertEquals(
            result[0].eksternVarsling.historikk[0].status,
            'bestilt',
            'Expected the first history element to be an order.');
    }

    @IsTest
    private static void getAllEventsAuraTest() {
        ApiMock.setTestMock('TMS_SERVICE_PATH', 200, 'OK');

        List<UN_TmsEventApiEvent> result;
        Test.startTest();
        result = UN_TmsEventApi.getAllEventsAura('123456789');
        xyzzy(result);
        Test.stopTest();

        System.assert(result.size() == 2 * 3, 'Expected to get two events three times');
        for (UN_TmsEventApiEvent e : result) {
            if (UN_TmsEventApi.PRODUCERS_TO_SKIP.contains(e.produsent)) {
                System.assert(
                    false,
                    'Event is created by the producer ' +
                    e.produsent +
                    ' and should be filtered out.'
                );
            }
        }
    }
}
