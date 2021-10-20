@IsTest
private with sharing class UN_BuilderValidationUtilTest {
    @IsTest
    static void validateNonNullField() {
        Test.startTest();
        try {
            UN_BuilderValidationUtil.validateNonNullField('Test', 'Empty field');
            System.assert(true, 'No exception');
        } catch (Exception ex) {
            System.assert(false, 'Wrong exception');
        }
        Test.stopTest();
    }

    @IsTest
    static void validateNonNullFieldException() {
        Test.startTest();
        try {
            UN_BuilderValidationUtil.validateStatusGlobal(null);
            System.assert(false, 'Expected exception to be thrown');
        } catch (UN_BuilderValidationUtil.FieldValidationException ex) {
            System.assert(true, 'Correct exception');
        } catch (Exception ex) {
            System.assert(false, 'Wrong exception');
        }
        Test.stopTest();
    }

    @IsTest
    static void validateStatusGlobal() {
        Test.startTest();
        UN_BuilderValidationUtil.validateStatusGlobal(UN_StatusGlobal.MOTTATT);
        System.assert(true, 'No exception');
        Test.stopTest();
    }

    @IsTest
    static void validateEventId() {
        Test.startTest();
        UN_BuilderValidationUtil.validateEventId(new Uuid().getValue());
        System.assert(true, 'No exception');
        Test.stopTest();
    }
}
