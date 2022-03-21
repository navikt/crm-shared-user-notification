public inherited sharing class UN_DoneEvent {
    public UN_NokkelInput nokkel;
    public UN_DoneInput done;

    public UN_DoneEvent(UserNotification__c userNotification) {
        this(
            UN_NokkelMapper.userNotificationToNokkelInput(userNotification),
            UN_DoneMapper.userNotificationToDoneInput(userNotification)
        );
    }

    public UN_DoneEvent(UN_NokkelInput nokkel, UN_DoneInput done) {
        this.nokkel = nokkel;
        this.done = done;
    }
}
