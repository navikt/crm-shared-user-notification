public with sharing class UN_InnboksBuilderLegacy {
    private DateTime tidspunkt;
    private String fodselsnummer;
    private String grupperingsId;
    private String tekst;
    private String link;
    private Integer sikkerhetsnivaa;

    public UN_InnboksBuilderLegacy() {
    }
    public UN_InnboksBuilderLegacy(UserNotification__c notification) {
        this.tidspunkt = notification.INT_EventTime__c;
        this.fodselsnummer = notification.INT_SocialSecurityNumber__c;
        this.grupperingsId = notification.INT_GroupingId__c;
        this.tekst = notification.INT_Description__c;
        this.link = notification.INT_Link__c;
        this.sikkerhetsnivaa = notification.INT_SecurityLevel__c == null
            ? null
            : notification.INT_SecurityLevel__c.IntValue();
    }

    public UN_InnboksBuilderLegacy withTidspunkt(DateTime tidspunkt) {
        this.tidspunkt = tidspunkt;
        return this;
    }

    public UN_InnboksBuilderLegacy withFodselsnummer(String fodselsnummer) {
        this.fodselsnummer = fodselsnummer;
        return this;
    }

    public UN_InnboksBuilderLegacy withGrupperingsId(String grupperingsId) {
        this.grupperingsId = grupperingsId;
        return this;
    }

    public UN_InnboksBuilderLegacy withTekst(String tekst) {
        this.tekst = tekst;
        return this;
    }

    public UN_InnboksBuilderLegacy withLink(String link) {
        this.link = link;
        return this;
    }

    public UN_InnboksBuilderLegacy withSikkerhetsnivaa(Integer sikkerhetsnivaa) {
        this.sikkerhetsnivaa = sikkerhetsnivaa;
        return this;
    }

    // prettier-ignore
    public UN_InnboksLegacy build() {
        UN_InnboksLegacy innboks = new UN_InnboksLegacy();

        innboks.tidspunkt = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(this.tidspunkt, 'tidspunkt', true);
        innboks.fodselsnummer = UN_BuilderValidationUtil.validateFodselsnummer(this.fodselsnummer);
        innboks.grupperingsId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength( this.grupperingsId, 'grupperingsId', UN_BuilderValidationUtil.MAX_LENGTH_GRUPPERINGSID );
        innboks.link = UN_BuilderValidationUtil.validateLinkAndConvertToString( this.link, 'link', UN_BuilderValidationUtil.MAX_LENGTH_LINK, UN_BuilderValidationUtil.isLinkRequired(UN_EventType.INNBOKS) );
        innboks.sikkerhetsnivaa = UN_BuilderValidationUtil.validateSikkerhetsnivaa(this.sikkerhetsnivaa);
        innboks.tekst = UN_BuilderValidationUtil.validateNonNullFieldMaxLength( this.tekst, 'tekst', UN_BuilderValidationUtil.MAX_LENGTH_TEXT_INNBOKS );

        return innboks;
    }
}