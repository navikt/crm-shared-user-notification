public with sharing class UserNotification_ProduceEventsOnAfter extends MyTriggers {
    private Map<String, Map<String, List<UserNotification__c>>> eventMap;

    public override void onAfterInsert() {
        eventMap = new Map<String, Map<String, List<UserNotification__c>>>();

        for (UserNotification__c notification : (List<UserNotification__c>) records) {
            if (UserNotification_Util.isUnpublishedMessage(notification)) {
                addNotificationToEventMap(notification);
            }
        }

        if (eventMap.size() > 0) {
            for (String systemUser : eventMap.keySet()) {
                produceMessages(systemUser, eventMap.get(systemUser));
            }
        }
    }

    private void produceMessages(String systemUser, Map<String, List<UserNotification__c>> notificationMap) {
        for (String eventType : notificationMap.keySet()) {
            EventProducer producer;
            if (notificationMap.containsKey('BESKJED')) {
                producer = new UserNotification_BeskjedProducer(systemUser, 'testTopic');
            }

            if (producer != null) {
                List<EventProducer.EventResult> results = producer.produceEvents(notificationMap.get(eventType));

                for (Integer i = 0; i < notificationMap.get(eventType).size(); i++) {
                    if (false == results[i].isSuccess) {
                        notificationMap.get(eventType)[i].addError(results[i].errorMessage);
                    }
                }

                producer.publishEvent();
            }
        }
    }

    private void addNotificationToEventMap(UserNotification__c notification) {
        if (eventMap.containsKey(notification.INT_SystemUser__c)) {
            eventMap.get(notification.INT_SystemUser__c).get(notification.INT_Type__c).add(notification);
        } else {
            eventMap.put(notification.INT_SystemUser__c, new Map<String, List<UserNotification__c>>());
            eventMap.get(notification.INT_SystemUser__c)
                .put(notification.INT_Type__c, new List<UserNotification__c>{ notification });
        }
    }
}
