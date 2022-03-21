public inherited sharing class UN_InnboksEvent {
    public UN_NokkelInput nokkel;
    public UN_InnboksInput innboksEvent;

    public UN_InnboksEvent(UserNotification__c userNotification) {
        this(
            UN_NokkelMapper.userNotificationToNokkelInput(userNotification),
            UN_InnboksMapper.userNotificationToInnboksInput(userNotification)
        );
    }
    public UN_InnboksEvent(UN_NokkelInput nokkel, UN_InnboksInput innboksEvent) {
        this.nokkel = nokkel;
        this.innboksEvent = innboksEvent;
    }
}
