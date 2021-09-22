public virtual with sharing class UN_EventProducerLegacy {
    private String systemUser;
    private String topic;
    @TestVisible
    private Event event;
    private List<EventResult> result;

    public UN_EventProducerLegacy(String systemUser, String topic) {
        this.systemUser = systemUser;
        this.topic = topic;
        result = new List<EventResult>();
    }

    public List<EventResult> produceEvents(List<Object> objList) {
        event = new Event();
        event.systemUser = systemUser;
        event.topic = topic;
        event.messages = new List<KafkaMessage>();

        for (Object o : objList) {
            try {
                event.messages.add(new KafkaMessage(createKey(o), createValue(o)));
                result.add(new EventResult(o, true, null));
            } catch (Exception e) {
                result.add(
                    new EventResult(
                        o,
                        false,
                        e.getTypeName() +
                        ': ' +
                        e.getMessage() +
                        ' Stack trace: ' +
                        e.getStackTraceString()
                    )
                );
            }
        }
        return result;
    }

    public UN_EventProducerLegacy produceEvents(Map<Object, Object> objMap) {
        event = new Event();
        event.systemUser = systemUser;
        event.topic = topic;
        event.messages = new List<KafkaMessage>();

        for (Object key : objMap.keySet()) {
            event.messages.add(new KafkaMessage(createKey(key), createValue(objMap.get(key))));
        }
        return this;
    }

    public UN_EventProducerLegacy produceEvents(List<KafkaMessage> messages) {
        event = new Event();
        event.systemUser = systemUser;
        event.topic = topic;
        event.messages = messages;
        return this;
    }

    public void publishEvent() {
        System.debug(event);
        LoggerUtility logger = new LoggerUtility();
        logger.info(JSON.serialize(event), null);
        logger.publishSynch();
    }

    protected virtual String createKey(Object o) {
        return 'key';
    }

    protected virtual String createValue(Object o) {
        return 'value';
    }

    public class EventResult {
        public Object message;
        public Boolean isSuccess;
        public String errorMessage;

        public EventResult(Object message, Boolean isSuccess, String errorMessage) {
            this.message = message;
            this.isSuccess = isSuccess;
            this.errorMessage = errorMessage;
        }
    }

    public class Event {
        public String systemUser;
        public String topic;
        public List<KafkaMessage> messages;
    }

    public class KafkaMessage {
        public String key;
        public String value;

        public KafkaMessage(String key, String value) {
            this.key = key;
            this.value = value;
        }
    }
}
