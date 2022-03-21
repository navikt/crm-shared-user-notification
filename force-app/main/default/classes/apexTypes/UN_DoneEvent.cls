public inherited sharing class UN_DoneEvent {
    public Datetime tidspunkt;

    //Key fields
    public String eventId;
    public String grupperingsId;
    public String fodselsnummer;

    public UN_DoneEvent(UserNotification__c userNotification) {
        this(
            UN_NokkelMapper.userNotificationToNokkelInput(userNotification),
            UN_DoneMapper.userNotificationToDoneInput(userNotification)
        );
    }

    public UN_DoneEvent(UN_NokkelInput nokkel, UN_DoneInput done) {
        this.tidspunkt = DateTime.newInstance(done.tidspunkt);

        // Set key fields
        this.eventId = nokkel.eventId;
        this.grupperingsId = nokkel.grupperingsId;
        this.fodselsnummer = nokkel.fodselsnummer;
    }
}
