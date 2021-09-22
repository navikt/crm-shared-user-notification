public with sharing class UN_BeskjedProducerLegacy extends UN_EventProducerLegacy {
    public UN_BeskjedProducerLegacy(String systemUser, String topic) {
        super(systemUser, topic);
    }

    protected override String createKey(Object notification) {
        return ''; //JSON.serialize(UN_NokkelBuilderLegacy.build((UserNotification__c) notification), true);
    }

    protected override string createValue(Object notification) {
        return ''; //JSON.serialize(UN_BeskjedBuilderLegacy.build((UserNotification__c) notification), true);
    }
}
