public with sharing class UserNotification_BeskjedProducer extends EventProducer {
    public UserNotification_BeskjedProducer(String systemUser, String topic) {
        super(systemUser, topic);
    }

    protected override String createKey(Object notification) {
        return JSON.serialize(UserNotification_NokkelBuilder.build((UserNotification__c) notification), true);
    }

    protected override string createValue(Object notification) {
        return JSON.serialize(UserNotification_BeskjedBuilder.build((UserNotification__c) notification), true);
    }
}
