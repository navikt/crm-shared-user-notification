public virtual inherited sharing class UN_EventProducer {
    protected UserNotification__c userNotification;
    protected UN_EventType eventType;
    protected UN_NokkelLegacy nokkel;
    protected String error;
    protected Object value;

    public UN_EventProducer(UN_EventType eventType) {
        this.userNotification = new UserNotification__c();
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
        this.userNotification.CRM_NotificationError__c = sfId;
        return this;
    }

    public UN_EventProducer publish() {
        try {
            switch on this.eventType {
                when INNBOKS {
                    UN_UserNotifications.publishInboksEvent((UN_InnboksLegacy) value, this.nokkel);
                }
                when DONE {
                    UN_UserNotifications.publishDoneEvent((UN_DoneLegacy) value, this.nokkel);
                }
            }
        } catch (Exception e) {
            return this.setError(e.getMessage());
        }
        return this;
    }

    public UN_EventProducer setError(String error) {
        this.error = error;
        return this;
    }

    public UN_EventProducer store() {
        insert this.userNotification;
        return this;
    }

    public UserNotification__c getUserNotification() {
        return this.userNotification;
    }

    public static List<UserNotification__c> publish(List<UN_EventProducer> produserList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();

        for (UN_EventProducer producer : produserList) {
            producer.publish();
            userNotifications.add(producer.getUserNotification());
        }

        upsert userNotifications INT_Key__c;

        return userNotifications;
    }
}
