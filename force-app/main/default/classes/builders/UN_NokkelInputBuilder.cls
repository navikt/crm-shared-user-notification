public inherited sharing class UN_NokkelInputBuilder {
    public String eventId;
    public String grupperingsId;
    public String fodselsnummer;
    public String namespace;
    public String appnavn;

    public UN_NokkelInputBuilder withEventId(String eventId) {
        this.eventId = eventId;
        return this;
    }

    public UN_NokkelInputBuilder withGrupperingsId(String grupperingsId) {
        this.grupperingsId = grupperingsId;
        return this;
    }

    public UN_NokkelInputBuilder withFodselsnummer(String fodselsnummer) {
        this.fodselsnummer = fodselsnummer;
        return this;
    }

    public UN_NokkelInputBuilder withNamespace(String namespace) {
        this.namespace = namespace;
        return this;
    }

    public UN_NokkelInputBuilder withAppnavn(String appnavn) {
        this.appnavn = appnavn;
        return this;
    }

    public UN_NokkelInput build() {
        UN_NokkelInput nokkel = new UN_NokkelInput();

        nokkel.eventId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.eventId,
            'eventId',
            UN_BuilderValidationUtil.MAX_LENGTH_EVENTID
        );
        nokkel.grupperingsId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.grupperingsId,
            'grupperingsId',
            UN_BuilderValidationUtil.MAX_LENGTH_GRUPPERINGSID
        );
        nokkel.fodselsnummer = UN_BuilderValidationUtil.validateFodselsnummer(this.fodselsnummer);
        nokkel.namespace = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.namespace,
            'namespace',
            UN_BuilderValidationUtil.MAX_LENGTH_NAMESPACE
        );
        nokkel.appnavn = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.appnavn,
            'appnavn',
            UN_BuilderValidationUtil.MAX_LENGTH_APP_NAME
        );
        return nokkel;
    }
}
