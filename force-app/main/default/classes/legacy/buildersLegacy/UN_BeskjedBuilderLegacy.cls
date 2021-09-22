public with sharing class UN_BeskjedBuilderLegacy {
    private DateTime tidspunkt;
    private DateTime synligFremTil;
    private String fodselsnummer;
    private String grupperingsId;
    private String tekst;
    private String link;
    private Integer sikkerhetsnivaa;
    private Boolean eksternVarsling = false;
    private List<String> prefererteKanaler;

    public UN_BeskjedBuilderLegacy() {
    }

    public UN_BeskjedBuilderLegacy(UserNotification__c notification) {
        this.tidspunkt = notification.INT_EventTime__c;
        this.tekst = notification.INT_Description__c;
        this.link = notification.INT_Link__c;
        this.sikkerhetsnivaa = notification.INT_SecurityLevel__c == null
            ? null
            : notification.INT_SecurityLevel__c.IntValue();
        this.synligFremTil = notification.INT_VisibleUntil__c;
        this.fodselsnummer = notification.INT_SocialSecurityNumber__c;
        this.grupperingsId = notification.INT_GroupingId__c;
        this.eksternVarsling = notification.INT_ExternalNotification__c;
        this.prefererteKanaler = UN_Util.multiSelectToList(notification.INT_PreferredChannel__c);
    }

    public UN_BeskjedBuilderLegacy withTidspunkt(DateTime tidspunkt) {
        this.tidspunkt = tidspunkt;
        return this;
    }

    public UN_BeskjedBuilderLegacy withSynligFremTil(DateTime synligFremTil) {
        this.synligFremTil = synligFremTil;
        return this;
    }

    public UN_BeskjedBuilderLegacy withFodselsnummer(String fodselsnummer) {
        this.fodselsnummer = fodselsnummer;
        return this;
    }

    public UN_BeskjedBuilderLegacy withGrupperingsId(String grupperingsId) {
        this.grupperingsId = grupperingsId;
        return this;
    }

    public UN_BeskjedBuilderLegacy withTekst(String tekst) {
        this.tekst = tekst;
        return this;
    }

    public UN_BeskjedBuilderLegacy withLink(String link) {
        this.link = link;
        return this;
    }

    public UN_BeskjedBuilderLegacy withSikkerhetsnivaa(Integer sikkerhetsnivaa) {
        this.sikkerhetsnivaa = sikkerhetsnivaa;
        return this;
    }

    public UN_BeskjedBuilderLegacy withEksternVarsling(Boolean eksternVarsling) {
        this.eksternVarsling = eksternVarsling;
        return this;
    }

    public UN_BeskjedBuilderLegacy withPrefererteKanaler(List<String> prefererteKanaler) {
        if (prefererteKanaler != null) {
            this.prefererteKanaler = prefererteKanaler;
        }
        return this;
    }

    public UN_BeskjedLegacy build() {
        UN_BeskjedLegacy beskjed = new UN_BeskjedLegacy();

        beskjed.tidspunkt = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(this.tidspunkt, 'tidspunkt', true);
        beskjed.synligFremTil = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(
            this.synligFremTil,
            'synligFremTil',
            false
        );
        beskjed.fodselsnummer = UN_BuilderValidationUtil.validateFodselsnummer(this.fodselsnummer);
        beskjed.grupperingsId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.grupperingsId,
            'grupperingsId',
            100
        );
        beskjed.tekst = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(this.tekst, 'tekst', 500);
        beskjed.link = UN_BuilderValidationUtil.validateLinkAndConvertToString(this.link, 'link', 200, false);
        beskjed.sikkerhetsnivaa = UN_BuilderValidationUtil.validateSikkerhetsnivaa(this.sikkerhetsnivaa);
        beskjed.eksternVarsling = this.eksternVarsling;
        beskjed.prefererteKanaler = UN_BuilderValidationUtil.validatePrefererteKanaler(
            this.eksternVarsling,
            this.prefererteKanaler
        );

        return beskjed;
    }
}
