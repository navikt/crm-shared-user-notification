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

    public UN_EventProducer publish() {
        try {
            switch on this.eventType {
                when INNBOKS {
                    this.userNotification.CRM_SuccessfullySentNotification__c = true;
                    UN_UserNotifications.publishInboksEvent(
                        (UN_InnboksLegacy) value,
                        this.nokkel,
                        this.isSystemContext
                    );
                }
                when DONE {
                    this.userNotification.CRM_SuccessfullySentDone__c = true;
                    UN_UserNotifications.publishDoneEvent((UN_DoneLegacy) value, this.nokkel, this.isSystemContext);
                }
            }
        } catch (Exception e) {
            return this.setError(e.getMessage());
        }
        return this;
    }

    public UN_EventProducer setError(String error) {
        this.userNotification.CRM_NotificationError__c = error;

        switch on this.eventType {
            when INNBOKS {
                this.userNotification.CRM_SuccessfullySentNotification__c = false;
            }
            when DONE {
                this.userNotification.CRM_SuccessfullySentDone__c = false;
            }
        }

        return this;
    }

    public UN_EventProducer store() {
        upsert this.userNotification INT_Key__c;
        return this;
    }

    public UserNotification__c getUserNotification() {
        return this.userNotification;
    }

    public Boolean isNewNotification() {
        return String.isBlank(getUserNotification().Id);
    }

    public static List<UserNotification__c> publish(List<UN_EventProducer> produserList) {
        List<UserNotification__c> userNotifications = new List<UserNotification__c>();
        List<UserNotification__c> userNotificationsInsert = new List<UserNotification__c>();
        List<UserNotification__c> userNotificationsUpdate = new List<UserNotification__c>();

        for (UN_EventProducer producer : produserList) {
            producer.publish();
            userNotifications.add(producer.getUserNotification());
            if (true == producer.isNewNotification()) {
                userNotificationsInsert.add(producer.getUserNotification());
            } else {
                userNotificationsUpdate.add(producer.getUserNotification());
            }
        }

        if (false == userNotificationsInsert.isEmpty()) {
            insert userNotificationsInsert;
        }

        if (false == userNotificationsUpdate.isEmpty()) {
            update userNotificationsUpdate;
        }

        return userNotifications;
    }

    public static UN_EventProducer getEventProducer(UserNotification__c un, Boolean isDoneEvent) {
        UN_EventType eventType = isDoneEvent ? UN_EventType.DONE : UN_EventType.valueOf(un.INT_Type__c);
        Object eventValue = null;

        switch on eventType {
            when INNBOKS {
                eventValue = UN_InnboksMapper.userNotificationToInnboksLegacy(un);
            }
            when DONE {
                if (un.CRM_Done__c) {
                    eventValue = UN_DoneMapper.userNotificationToDoneLegacy(un);
                }
            }
        }

        return new UN_EventProducer(eventType, un)
            .setKey(UN_NokkelMapper.userNotificationToNokkelLegacy(un))
            .setAccountId(un.CRM_Account__c)
            .setRelatedSfRecord(un.CRM_RelatedSfRecord__c)
            .setValue(eventValue);
    }
}
