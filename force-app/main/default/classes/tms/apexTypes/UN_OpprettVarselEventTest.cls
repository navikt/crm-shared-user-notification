@isTest
private class UN_OpprettVarselEventTest {
    @isTest
    static void testValidConstructionAndValidation() {
        UN_Type type = UN_Type.INNBOKS;
        String varselId = '12345678-1234-1234-1234-1234567890ab';
        String ident = '12345678901';
        List<UN_Tekst> tekster = new List<UN_Tekst>{ new UN_Tekst('nb', 'tekst', true) };
        String link = 'https://domain.no/test';
        UN_Sensitivitet sens = UN_Sensitivitet.HIGH;
        String aktivFremTil = null;
        UN_Kanal kanal = UN_Kanal.SMS;
        UN_EksternVarsling ekst = new UN_EksternVarsling(kanal);
        UN_Produsent produsent = new UN_Produsent('cluster-1', 'default', 'app');
        UN_OpprettVarselEvent evt = new UN_OpprettVarselEvent(
            type,
            varselId,
            ident,
            tekster,
            link,
            sens,
            aktivFremTil,
            ekst,
            produsent
        );
        evt.validate();
    }

    @isTest
    static void testValidation_MissingType() {
        try {
            buildValidEventWithAllOverrides(
                    null,
                    null,
                    null,
                    null,
                    null,
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('type is required', e.getMessage());
        }
    }

    @isTest
    static void testValidation_InvalidVarselId() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    'bad',
                    null,
                    null,
                    null,
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('varselId must be valid UUID or ULID', e.getMessage());
        }
    }

    @isTest
    static void testValidation_InvalidIdent() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    'badIdent',
                    null,
                    null,
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('ident must be exactly 11 digits', e.getMessage());
        }
    }

    @isTest
    static void testValidation_EmptyTekster() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    null,
                    new List<UN_Tekst>(),
                    null,
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('tekster must have at least one entry', e.getMessage());
        }
    }

    @isTest
    static void testValidation_InvalidTeksterLanguage() {
        List<UN_Tekst> tekster = new List<UN_Tekst>{ new UN_Tekst('rubbish', 'te', true) };
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    null,
                    tekster,
                    null,
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('tekster has invalid language code', e.getMessage());
        }
    }

    @isTest
    static void testValidation_InvalidLink() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    null,
                    null,
                    'ftp://wrong.com',
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('link must be complete URL', e.getMessage());
        }
    }

    @isTest
    static void testValidation_MissingSensitivitet() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('sensitivitet is required', e.getMessage());
        }
    }

    @isTest
    static void testValidation_InvalidAktivFremTil() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    null,
                    null,
                    null,
                    UN_Sensitivitet.HIGH,
                    'notADate',
                    null,
                    new UN_Produsent('cluster', 'namespace', 'app')
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('aktivFremTil invalid format', e.getMessage());
        }
    }

    @isTest
    static void testValidation_NullProdusentField() {
        try {
            buildValidEventWithAllOverrides(
                    UN_Type.INNBOKS,
                    null,
                    null,
                    null,
                    null,
                    UN_Sensitivitet.HIGH,
                    null,
                    null,
                    null
                )
                .validate();
            Assert.fail();
        } catch (UN_OpprettVarselEvent.OpprettVarselValidationException e) {
            Assert.areEqual('produsent fields required', e.getMessage());
        }
    }

    private static UN_OpprettVarselEvent buildValidEventWithAllOverrides(
        UN_Type typeOverride,
        String varselIdOverride,
        String identOverride,
        List<UN_Tekst> teksterOverride,
        String linkOverride,
        UN_Sensitivitet sensitivitetOverride,
        String aktivFremTilOverride,
        UN_EksternVarsling eksternVarslingOverride,
        UN_Produsent produsentOverride
    ) {
        UN_Type type = typeOverride;
        String varselId = (varselIdOverride != null) ? varselIdOverride : '12345678-9999-8888-7777-999999999999';
        String ident = (identOverride != null) ? identOverride : '12345678901';
        List<UN_Tekst> tekster = (teksterOverride != null)
            ? teksterOverride
            : new List<UN_Tekst>{ new UN_Tekst('nb', 't', true) };
        String link = (linkOverride != null) ? linkOverride : 'https://foo.bar';
        UN_Sensitivitet sensitivitet = sensitivitetOverride;
        String aktivFremTil = aktivFremTilOverride;
        UN_EksternVarsling ekst = (eksternVarslingOverride != null)
            ? eksternVarslingOverride
            : new UN_EksternVarsling(UN_Kanal.SMS);
        UN_Produsent produsent = produsentOverride;
        return new UN_OpprettVarselEvent(
            type,
            varselId,
            ident,
            tekster,
            link,
            sensitivitet,
            aktivFremTil,
            ekst,
            produsent
        );
    }
}
