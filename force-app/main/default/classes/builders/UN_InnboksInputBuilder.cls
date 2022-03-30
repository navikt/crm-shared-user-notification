public inherited sharing class UN_InnboksInputBuilder {
    public DateTime tidspunkt;
    public String tekst;
    public String link;
    public Integer sikkerhetsnivaa;
    public Boolean eksternVarsling = false;
    public List<UN_PreferertKanal> prefererteKanaler;
    public String epostVarslingstekst;
    public String epostVarslingstittel;
    public String smsVarslingstekst;

    public UN_InnboksInputBuilder withTidspunkt(DateTime tidspunkt) {
        this.tidspunkt = tidspunkt;
        return this;
    }

    public UN_InnboksInputBuilder withTekst(String tekst) {
        this.tekst = tekst;
        return this;
    }

    public UN_InnboksInputBuilder withLink(String link) {
        this.link = link;
        return this;
    }

    public UN_InnboksInputBuilder withSikkerhetsnivaa(Decimal sikkerhetsnivaa) {
        this.sikkerhetsnivaa = sikkerhetsnivaa.intValue();
        return this;
    }

    public UN_InnboksInputBuilder withEksternVarsling(Boolean eksternVarsling) {
        this.eksternVarsling = eksternVarsling;
        return this;
    }

    public UN_InnboksInputBuilder withPreferertKanal(UN_PreferertKanal preferertKanal) {
        if (this.prefererteKanaler == null) {
            this.prefererteKanaler = new List<UN_PreferertKanal>();
        }
        this.prefererteKanaler.add(preferertKanal);

        return this;
    }

    public UN_InnboksInputBuilder withPrefererteKanaler(List<UN_PreferertKanal> prefererteKanaler) {
        this.prefererteKanaler = prefererteKanaler;
        return this;
    }

    public UN_InnboksInputBuilder withPrefererteKanaler(String prefererteKanaler) {
        List<UN_PreferertKanal> kanaler;
        if (String.isNotBlank(prefererteKanaler)) {
            for (String kanal : prefererteKanaler.split(',')) {
                if (String.isBlank(kanal)) {
                    continue;
                }

                if (kanaler == null) {
                    kanaler = new List<UN_PreferertKanal>();
                }

                kanaler.add(UN_PreferertKanal.valueOf(kanal));
            }

            this.prefererteKanaler = kanaler;
        }
        return this;
    }

    public UN_InnboksInputBuilder withEpostVarslingstekst(String epostVarslingstekst) {
        this.epostVarslingstekst = epostVarslingstekst;
        return this;
    }

    public UN_InnboksInputBuilder withEpostVarslingstittel(String epostVarslingstittel) {
        this.epostVarslingstittel = epostVarslingstittel;
        return this;
    }

    public UN_InnboksInputBuilder withSmsVarslingstekst(String smsVarslingstekst) {
        this.smsVarslingstekst = smsVarslingstekst;
        return this;
    }

    public UN_InnboksInput build() {
        UN_InnboksInput innboks = new UN_InnboksInput();

        innboks.tidspunkt = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(this.tidspunkt, 'tidspunkt', true)
            .getTime();
        innboks.tekst = UN_BuilderValidationUtil.validateNonNullFieldMaxLength(
            this.tekst,
            'tekst',
            UN_BuilderValidationUtil.MAX_LENGTH_TEXT_INNBOKS
        );
        innboks.link = UN_BuilderValidationUtil.validateLinkAndConvertToString(
            this.link,
            'link',
            UN_BuilderValidationUtil.MAX_LENGTH_LINK,
            UN_BuilderValidationUtil.isLinkRequired(UN_EventType.INNBOKS)
        );
        innboks.sikkerhetsnivaa = UN_BuilderValidationUtil.validateSikkerhetsnivaa(this.sikkerhetsnivaa);
        innboks.eksternVarsling = this.eksternVarsling;
        innboks.prefererteKanaler = UN_BuilderValidationUtil.validatePrefererteKanaler(
            this.eksternVarsling,
            this.prefererteKanaler
        );
        innboks.epostVarslingstekst = UN_BuilderValidationUtil.validateEksternVarslingstekst(
            'epostVarslingstekst',
            this.eksternVarsling,
            this.epostVarslingstekst
        );
        innboks.epostVarslingstittel = UN_BuilderValidationUtil.validateEksternVarslingstekst(
            'epostVarslingstittel',
            this.eksternVarsling,
            this.epostVarslingstittel
        );
        innboks.smsVarslingstekst = UN_BuilderValidationUtil.validateEksternVarslingstekst(
            'smsVarslingstekst',
            this.eksternVarsling,
            this.smsVarslingstekst
        );
        return innboks;
    }
}
