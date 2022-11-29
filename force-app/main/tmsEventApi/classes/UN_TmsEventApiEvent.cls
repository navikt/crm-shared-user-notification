public virtual class UN_TmsEventApiEvent {
    @AuraEnabled
    public String uid;
    @AuraEnabled
    public String fodselsnummer;
    @AuraEnabled
    public String grupperingsId;
    @AuraEnabled
    public String eventId;
    @AuraEnabled
    public String eventTidspunkt;
    @AuraEnabled
    public DateTime eventTidspunktDT {
        get {
            return getDtFromString(eventTidspunkt);
        }
    }
    @AuraEnabled
    public String forstBehandlet;
    @AuraEnabled
    public DateTime forstBehandletDT {
        get {
            return getDtFromString(forstBehandlet);
        }
    }
    @AuraEnabled
    public String produsent;
    @AuraEnabled
    public Integer sikkerhetsnivaa;
    @AuraEnabled
    public String sistOppdatert;
    @AuraEnabled
    public DateTime sistOppdatertDT {
        get {
            return getDtFromString(sistOppdatert);
        }
    }
    @AuraEnabled
    public String tekst;
    @AuraEnabled
    public String link;
    @AuraEnabled
    public Boolean aktiv;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String typeLabel;
    @AuraEnabled
    public Boolean eksternVarslingSendt;
    @AuraEnabled
    public List<String> eksternVarslingKanaler;

    private Datetime getDtFromString(String stringDT) {
        return String.isBlank(stringDT) ? null : DateTime.valueOf(stringDT.substringBefore('[').replace('T', ' '));
    }
}
