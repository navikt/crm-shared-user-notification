public inherited sharing class UN_DittNavEvent {
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
            return String.isBlank(eventTidspunkt) ? null : DateTime.valueOf(eventTidspunkt.substringBefore('['));
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
            return String.isBlank(sistOppdatert) ? null : DateTime.valueOf(sistOppdatert.substringBefore('['));
        }
    }
    @AuraEnabled
    public String tekst;
    @AuraEnabled
    public String link;
    @AuraEnabled
    public Boolean aktiv;
}
