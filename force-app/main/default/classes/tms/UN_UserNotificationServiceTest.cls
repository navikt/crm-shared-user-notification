@isTest
private class UN_UserNotificationServiceTest {
    @isTest
    static void testPostOpprettVarselEvent_success_and_buildEventPayload() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, '{"result":"ok"}');
        UN_Tekst tekst = new UN_Tekst('nb', 'Tittel', true);
        List<UN_Tekst> tekster = new List<UN_Tekst>{ tekst };
        UN_EksternVarsling eksternVarsling = new UN_EksternVarsling(
            new List<UN_Kanal>{ UN_Kanal.SMS, UN_Kanal.EPOST },
            'smsText',
            'epostTitle',
            'epostBody',
            true
        );
        UN_Produsent produsent = new UN_Produsent('cluster', 'namespace', 'appnavn');
        UN_OpprettVarselEvent event = new UN_OpprettVarselEvent(
            UN_Type.INNBOKS,
            '12345678-aaaa-bbbb-cccc-1234567890ab',
            '12345678901',
            tekster,
            'https://domain.no/link',
            UN_Sensitivitet.HIGH,
            '2025-12-01T18:00:00.000Z',
            eksternVarsling,
            produsent
        );
        Test.startTest();
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(event, false);
        Test.stopTest();
        Assert.isNotNull(resp);
        Assert.areEqual(200, resp.getStatusCode());
        Assert.isTrue(resp.getBody().contains('ok'));
    }

    @isTest
    static void testPostOpprettVarselEvent_withMinimalData() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, '{"result":"minimal"}');
        UN_OpprettVarselEvent event = new UN_OpprettVarselEvent(
            UN_Type.INNBOKS,
            '12345678-bbbb',
            '12345678901',
            new List<UN_Tekst>{ new UN_Tekst('nb', 'Tittel', true) },
            null,
            UN_Sensitivitet.SUBSTANTIAL,
            null,
            null,
            null
        );
        Test.startTest();
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(event, true);
        Test.stopTest();
        Assert.isNotNull(resp);
        Assert.areEqual(200, resp.getStatusCode());
    }

    @isTest
    static void testBuildEventPayload_fullAndMinimal() {
        UN_Tekst tekst = new UN_Tekst('nb', 'Tekst', true);
        List<UN_Tekst> tekster = new List<UN_Tekst>{ tekst };
        UN_EksternVarsling eksternVarsling = new UN_EksternVarsling(
            new List<UN_Kanal>{ UN_Kanal.SMS },
            'sms',
            'epostT',
            'epostB',
            false
        );
        UN_Produsent produsent = new UN_Produsent('c', 'n', 'a');
        UN_OpprettVarselEvent fullEvent = new UN_OpprettVarselEvent(
            UN_Type.INNBOKS,
            'id-99',
            '12345678901',
            tekster,
            'https://test.com',
            UN_Sensitivitet.HIGH,
            '2025-11-21 11:11:11',
            eksternVarsling,
            produsent
        );
        Map<String, Object> payload = UN_UserNotificationService.buildEventPayload(fullEvent);

        Assert.areEqual('opprett', payload.get('@event_name'));
        Assert.areEqual('innboks', payload.get('type'));
        Assert.areEqual('12345678901', payload.get('ident'));
        Assert.isTrue(payload.containsKey('tekster'));
        Assert.isTrue(((List<Object>) payload.get('tekster')).size() > 0, 'tekster not populated');
        Assert.areEqual('https://test.com', payload.get('link'));
        Assert.areEqual('high', payload.get('sensitivitet'));
        Assert.areEqual('2025-11-21 11:11:11', payload.get('aktivFremTil'));
        Assert.isTrue(payload.containsKey('eksternVarsling'));
        Assert.isTrue(payload.containsKey('produsent'));

        UN_OpprettVarselEvent testEvent = new UN_OpprettVarselEvent(
            UN_Type.INNBOKS,
            'minid-01',
            '99887766554',
            new List<UN_Tekst>{ new UN_Tekst('nb', 'bare', true) },
            null,
            UN_Sensitivitet.SUBSTANTIAL,
            null,
            null,
            null
        );
        Map<String, Object> minPayload = UN_UserNotificationService.buildEventPayload(testEvent);

        Assert.areEqual('opprett', minPayload.get('@event_name'));
        Assert.areEqual('innboks', minPayload.get('type'));
        Assert.areEqual('99887766554', minPayload.get('ident'));
        Assert.isTrue(minPayload.containsKey('tekster'));
        Assert.isFalse(minPayload.containsKey('eksternVarsling'));
        Assert.isFalse(minPayload.containsKey('produsent'));
    }

    @isTest
    static void testPostOpprettVarselEvent_noTeksterOrEksternVarslingOrProdusent() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, '{"result":"empty"}');
        UN_OpprettVarselEvent event = new UN_OpprettVarselEvent(
            UN_Type.INNBOKS,
            'x-plain',
            '12345678901',
            new List<UN_Tekst>(),
            null,
            UN_Sensitivitet.HIGH,
            null,
            null,
            null
        );
        Test.startTest();
        HttpResponse resp = UN_UserNotificationService.postOpprettVarselEvent(event, false);
        Test.stopTest();
        Assert.isNotNull(resp);
        Assert.areEqual(200, resp.getStatusCode());
    }
}
