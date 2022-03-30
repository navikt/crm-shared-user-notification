public inherited sharing class UN_InnboksEvent {
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

    public UN_InnboksEvent(UserNotification__c userNotification) {
        this(
            UN_NokkelMapper.userNotificationToNokkelInput(userNotification),
            UN_InnboksMapper.userNotificationToInnboksInput(userNotification)
        );
    }

    public UN_InnboksEvent(UN_NokkelInput nokkel, UN_InnboksInput innboksEvent) {
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
