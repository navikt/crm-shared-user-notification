public virtual class UN_TmsEventApiEvent {

    public class EksternVarsling {
        @AuraEnabled
        public Boolean sendt;
        @AuraEnabled
        public Boolean renotifikasjonSendt;
        @AuraEnabled
        public List<String> prefererteKanaler;
        @AuraEnabled
        public List<String> sendteKanaler;
        @AuraEnabled
        public List<EksternVarslingHistorikkEntry> historikk;
    }

    public class EksternVarslingHistorikkEntry {
        @AuraEnabled
        public String melding;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Long distribusjonsId;
        @AuraEnabled
        public String kanal;
        @AuraEnabled
        public Boolean renotifikasjon;
        @AuraEnabled
        public String tidspunkt;
        @AuraEnabled
        public DateTime tidspunktDT {
            get {
                return getDtFromString(tidspunkt);
            }
        }
        private Datetime getDtFromString(String stringDT) {
            return String.isBlank(stringDT) ? null : DateTime.valueOf(stringDT.substringBefore('[').replace('T', ' '));
        }
    }

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
    public EksternVarsling eksternVarsling;
    @AuraEnabled
    public Boolean eksternVarslingSendt;
    @AuraEnabled
    public List<String> eksternVarslingKanaler;

    private Datetime getDtFromString(String stringDT) {
        return String.isBlank(stringDT) ? null : DateTime.valueOf(stringDT.substringBefore('[').replace('T', ' '));
    }
}
