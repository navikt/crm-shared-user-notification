public inherited sharing class UN_OldInnboksEvent {
    public Datetime tidspunkt;
    public String tekst;
    public String link;
    public Integer sikkerhetsnivaa;
    public Boolean eksternVarsling;
    public String prefererteKanaler;
    public String epostVarslingstekst;
    public String epostVarslingstittel;
    public String smsVarslingstekst;

    //Key fields
    public String eventId;
    public String grupperingsId;
    public String fodselsnummer;

    public UN_OldInnboksEvent(UserNotification__c userNotification) {
        this(
            UN_NokkelMapper.userNotificationToNokkelInput(userNotification),
            UN_OldInnboksMapper.userNotificationToInnboksInput(userNotification)
        );
    }

    public UN_OldInnboksEvent(UN_NokkelInput nokkel, UN_InnboksInput innboksEvent) {
        this.tidspunkt = DateTime.newInstance(innboksEvent.tidspunkt);
        this.tekst = innboksEvent.tekst;
        this.link = innboksEvent.link;
        this.sikkerhetsnivaa = innboksEvent.sikkerhetsnivaa;
        this.eksternVarsling = innboksEvent.eksternVarsling;
        this.prefererteKanaler = String.join(innboksEvent.prefererteKanaler, ',');
        this.epostVarslingstekst = innboksEvent.epostVarslingstekst;
        this.epostVarslingstittel = innboksEvent.epostVarslingstittel;
        this.smsVarslingstekst = innboksEvent.smsVarslingstekst;

        // Set key fields
        this.eventId = nokkel.eventId;
        this.grupperingsId = nokkel.grupperingsId;
        this.fodselsnummer = nokkel.fodselsnummer;
    }
}
