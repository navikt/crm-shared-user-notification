public with sharing class UserNotification_Nokkel {
    public String systembruker;
    public String eventId;

    public String key {
        get {
            return systembruker + eventId;
        }
        private set;
    }

    public UserNotification_Nokkel() {
        systembruker = null;
        eventId = null;
    }

    public UserNotification_Nokkel(String systembruker, String eventId) {
        this.systembruker = systembruker;
        this.eventId = eventId;
    }
}
