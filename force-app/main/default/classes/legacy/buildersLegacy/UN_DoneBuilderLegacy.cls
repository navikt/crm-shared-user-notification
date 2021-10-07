public inherited sharing class UN_DoneBuilderLegacy {
    private DateTime tidspunkt;
    private String fodselsnummer;
    private String grupperingsId;

    public UN_DoneBuilderLegacy withTidspunkt(DateTime tidspunkt) {
        this.tidspunkt = tidspunkt;
        return this;
    }

    public UN_DoneBuilderLegacy withFodselsnummer(String fodselsnummer) {
        this.fodselsnummer = fodselsnummer;
        return this;
    }

    public UN_DoneBuilderLegacy withGrupperingsId(String grupperingsId) {
        this.grupperingsId = grupperingsId;
        return this;
    }

    // prettier-ignore
    public UN_DoneLegacy build() {
        UN_DoneLegacy done = new UN_DoneLegacy();
        done.tidspunkt = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(this.tidspunkt, 'tidspunkt', UN_BuilderValidationUtil.IS_REQUIRED_TIDSPUNKT);
        done.fodselsnummer = UN_BuilderValidationUtil.validateFodselsnummer(this.fodselsnummer);
        done.grupperingsId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(this.grupperingsId, 'grupperingsId', UN_BuilderValidationUtil.MAX_LENGTH_GRUPPERINGSID);
        return done;
    }
}
