public virtual inherited sharing class UN_EventProducer {
    protected UserNotification__c userNotification;
    protected UN_EventType eventType;
    protected UN_NokkelLegacy nokkel;
    protected Object value;
    protected Boolean isSystemContext = false;

    public UN_EventProducer(UN_EventType eventType) {
        this(eventType, new UserNotification__c());
    }

    public UN_EventProducer(UN_EventType eventType, UserNotification__c userNotification) {
        this.userNotification = userNotification;
        this.eventType = eventType;
    }

    public UN_EventProducer setValue(Object value) {
        this.value = value;

        switch on this.eventType {
            when INNBOKS {
                UN_InnboksMapper.innboksLegacyToUserNotification((UN_InnboksLegacy) value, this.userNotification);
            }
            when DONE {
                UN_DoneMapper.doneLegacyToUserNotification((UN_DoneLegacy) value, this.userNotification);
            }
        }

        return this;
    }

    public UN_EventProducer setKey(UN_NokkelLegacy nokkel) {
        this.nokkel = nokkel;
        UN_NokkelMapper.nokkelLegacyToUserNotification(nokkel, this.userNotification);

        return this;
    }

    public UN_EventProducer setAccountId(Id accountId) {
        this.userNotification.CRM_Account__c = accountId;
        return this;
    }

    public UN_EventProducer setRelatedSfRecord(String sfId) {
        this.userNotification.CRM_RelatedSfRecord__c = sfId;
        return this;
    }

    public UN_EventProducer setSystemContext() {
        this.isSystemContext = true;
        return this;
    }

    public UserNotification__c getUserNotification() {
        return this.userNotification;
    }

    public static List<UserNotification__c> publish(List<UN_EventProducer> produserList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        List<UserNotification__c> doneUserNotifications = new List<UserNotification__c>();
        List<UserNotification__c> innboksUserNotifications = new List<UserNotification__c>();

        for (UN_EventProducer producer : produserList) {
            switch on producer.eventType {
                when INNBOKS {
                    innboksUserNotifications.add(producer.getUserNotification());
                }
                when DONE {
                    doneUserNotifications.add(producer.getUserNotification());
                }
            }
        }

        if (false == innboksUserNotifications.isEmpty()) {
            userNotifications.addAll(UN_UserNotifications.publishInboksEvent(innboksUserNotifications, true));
        }

        if (false == doneUserNotifications.isEmpty()) {
            userNotifications.addAll(UN_UserNotifications.publishDoneEvent(innboksUserNotifications, true));
        }

        return userNotifications;
    }
}
