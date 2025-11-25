@IsTest
public class UN_InaktiverEventTest {
    @IsTest
    static void testValidate_shouldPassWithValidData() {
        UN_Produsent validProdusent = new UN_Produsent();
        validProdusent.cluster = 'cluster';
        validProdusent.namespace = 'namespace';
        validProdusent.appnavn = 'appnavn';

        UN_InaktiverVarselEvent evt = new UN_InaktiverVarselEvent('0123456789abcdef', validProdusent);
        evt.validate();
    }

    @IsTest
    static void testValidate_shouldFailWithInvalidVarselId() {
        UN_Produsent validProdusent = new UN_Produsent();
        validProdusent.cluster = 'cluster';
        validProdusent.namespace = 'namespace';
        validProdusent.appnavn = 'appnavn';

        UN_InaktiverVarselEvent evt = new UN_InaktiverVarselEvent('invalid_id', validProdusent);
        try {
            evt.validate();
            Assert.fail();
        } catch (UN_InaktiverVarselEvent.InaktiverVarselValidationException e) {
            Assert.areEqual('varselId must be valid UUID or ULID', e.getMessage());
        }
    }

    @IsTest
    static void testValidate_shouldFailWithMissingProdusent() {
        UN_InaktiverVarselEvent evt = new UN_InaktiverVarselEvent('0123456789abcdef', null);
        try {
            evt.validate();
            Assert.fail();
        } catch (UN_InaktiverVarselEvent.InaktiverVarselValidationException e) {
            Assert.areEqual('produsent fields required', e.getMessage());
        }
    }
}
