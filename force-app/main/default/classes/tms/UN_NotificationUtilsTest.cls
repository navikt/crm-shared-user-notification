@isTest
private class UN_NotificationUtilsTest {
    @isTest
    static void testTypeIsValid() {
        Assert.isTrue(UN_NotificationUtils.typeIsValid('INNBOKS'));
        Assert.isTrue(UN_NotificationUtils.typeIsValid('innboks'));
        Assert.isFalse(UN_NotificationUtils.typeIsValid('notatype'));
        Assert.isFalse(UN_NotificationUtils.typeIsValid(''));
        Assert.isFalse(UN_NotificationUtils.typeIsValid(null));
    }

    @isTest
    static void testKanalIsValid() {
        Assert.isTrue(UN_NotificationUtils.kanalIsValid('SMS'));
        Assert.isTrue(UN_NotificationUtils.kanalIsValid('epost'));
        Assert.isFalse(UN_NotificationUtils.kanalIsValid('xxx'));
        Assert.isFalse(UN_NotificationUtils.kanalIsValid(null));
        Assert.isFalse(UN_NotificationUtils.kanalIsValid(''));
    }

    @isTest
    static void testSensitivitetIsValid() {
        Assert.isTrue(UN_NotificationUtils.sensitivitetIsValid('HIGH'));
        Assert.isTrue(UN_NotificationUtils.sensitivitetIsValid('SUBSTANTIAL'));
        Assert.isFalse(UN_NotificationUtils.sensitivitetIsValid('xxx'));
        Assert.isFalse(UN_NotificationUtils.sensitivitetIsValid(null));
        Assert.isFalse(UN_NotificationUtils.sensitivitetIsValid(''));
    }

    @isTest
    static void testIsValidISO8601() {
        Assert.isTrue(UN_NotificationUtils.isValidISO8601('2025-11-20 11:30:00'));
        Assert.isFalse(UN_NotificationUtils.isValidISO8601('badvalue'));
        Assert.isFalse(UN_NotificationUtils.isValidISO8601(''));
        Assert.isFalse(UN_NotificationUtils.isValidISO8601(null));
    }

    @isTest
    static void testFromString() {
        Assert.areEqual(UN_Sensitivitet.HIGH, UN_NotificationUtils.fromString('HIGH'));
        Assert.areEqual(UN_Sensitivitet.SUBSTANTIAL, UN_NotificationUtils.fromString('SUBSTANTIAL'));
        Assert.isNull(UN_NotificationUtils.fromString('garbage'));
        Assert.isNull(UN_NotificationUtils.fromString(''));
        Assert.isNull(UN_NotificationUtils.fromString(null));
    }

    @isTest
    static void testParseTekster_withJson() {
        String description = '[{"spraakkode":"nb","tekst":"tittel 1","default":true},{"spraakkode":"nn","tekst":"tittel 2","default":false}]';
        List<UN_Tekst> tekster = UN_NotificationUtils.parseTekster(description);
        Assert.areEqual(2, tekster.size());
        Assert.areEqual('nb', tekster[0].spraakkode);
        Assert.isTrue(tekster[0].defaultValue);
        Assert.areEqual('nn', tekster[1].spraakkode);
    }

    @isTest
    static void testParseTekster_withFallback() {
        String description = 'tekst1;tekst2';
        List<UN_Tekst> tekster = UN_NotificationUtils.parseTekster(description);
        Assert.areEqual(2, tekster.size());
        Assert.areEqual('no', tekster[0].spraakkode);
        Assert.areEqual('tekst1', tekster[0].tekst);
        Assert.isTrue(tekster[0].defaultValue);
        Assert.isFalse(tekster[1].defaultValue);
    }

    @isTest
    static void testSerializeTekster_json() {
        List<UN_Tekst> input = new List<UN_Tekst>{ new UN_Tekst('nb', 'A', true), new UN_Tekst('nn', 'B', false) };
        String s = UN_NotificationUtils.serializeTekster(input);
        Assert.isTrue(s.startsWith('['));
        Assert.isTrue(s.contains('"spraakkode":"nb"'));
    }

    @isTest
    static void testSerializeTekster_semicolon() {
        List<UN_Tekst> input = new List<UN_Tekst>{ new UN_Tekst('no', 'A', true) };
        String s = UN_NotificationUtils.serializeTekster(input);
        Assert.areEqual('A', s);
    }

    @isTest
    static void testSerializeTekster_empty() {
        Assert.areEqual('', UN_NotificationUtils.serializeTekster(new List<UN_Tekst>()));
        Assert.areEqual('', UN_NotificationUtils.serializeTekster(null));
    }

    @isTest
    static void testRemoveNulls() {
        Map<String, Object> m = new Map<String, Object>{ 'A' => 'a', 'B' => null, 'C' => 3 };
        UN_NotificationUtils.removeNulls(m);
        Assert.isTrue(m.containsKey('A'));
        Assert.isTrue(m.containsKey('C'));
        Assert.isFalse(m.containsKey('B'));
    }
}
