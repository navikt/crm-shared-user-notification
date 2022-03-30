public inherited sharing class UN_DoneInputBuilder {
    public DateTime tidspunkt;

    public UN_DoneInputBuilder withTidspunkt(Datetime tidspunkt) {
        this.tidspunkt = tidspunkt;
        return this;
    }

    public UN_DoneInput build() {
        UN_DoneInput done = new UN_DoneInput();
        done.tidspunkt = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(
                this.tidspunkt,
                'tidspunkt',
                UN_BuilderValidationUtil.IS_REQUIRED_TIDSPUNKT
            )
            .getTime();
        return done;
    }
}
