public with sharing class UN_InnboksBuilderLegacy {
    private DateTime tidspunkt;
    private String fodselsnummer;
    private String grupperingsId;
    private String tekst;
    private String link;
    private Integer sikkerhetsnivaa;
    public Boolean eksternVarsling;
    public List<UN_PreferertKanal> prefererteKanaler;

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

    public UN_InnboksBuilderLegacy withSikkerhetsnivaa(Decimal sikkerhetsnivaa) {
        this.withSikkerhetsnivaa(sikkerhetsnivaa.intValue());
        return this;
    }

    public UN_InnboksBuilderLegacy withSikkerhetsnivaa(Integer sikkerhetsnivaa) {
        this.sikkerhetsnivaa = sikkerhetsnivaa;
        return this;
    }

    public UN_InnboksBuilderLegacy withEksternVarsling(Boolean eksternVarsling) {
        this.eksternVarsling = eksternVarsling;
        return this;
    }

    public UN_InnboksBuilderLegacy withPrefererteKanaler(List<UN_PreferertKanal> prefererteKanaler) {
        this.prefererteKanaler = prefererteKanaler;
        return this;
    }

    public UN_InnboksBuilderLegacy withPrefererteKanaler(String prefererteKanaler) {
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

    // prettier-ignore
    public UN_InnboksLegacy build() {
        UN_InnboksLegacy innboks = new UN_InnboksLegacy();

        innboks.tidspunkt = UN_BuilderValidationUtil.localDateTimeToUtcTimestamp(this.tidspunkt, 'tidspunkt', true);
        innboks.fodselsnummer = UN_BuilderValidationUtil.validateFodselsnummer(this.fodselsnummer);
        innboks.grupperingsId = UN_BuilderValidationUtil.validateNonNullFieldMaxLength( this.grupperingsId, 'grupperingsId', UN_BuilderValidationUtil.MAX_LENGTH_GRUPPERINGSID );
        innboks.link = UN_BuilderValidationUtil.validateLinkAndConvertToString( this.link, 'link', UN_BuilderValidationUtil.MAX_LENGTH_LINK, UN_BuilderValidationUtil.isLinkRequired(UN_EventType.INNBOKS) );
        innboks.sikkerhetsnivaa = UN_BuilderValidationUtil.validateSikkerhetsnivaa(this.sikkerhetsnivaa);
        innboks.tekst = UN_BuilderValidationUtil.validateNonNullFieldMaxLength( this.tekst, 'tekst', UN_BuilderValidationUtil.MAX_LENGTH_TEXT_INNBOKS );
        innboks.eksternVarsling = this.eksternVarsling;
        innboks.prefererteKanaler = UN_BuilderValidationUtil.validatePrefererteKanalerLegacy(this.eksternVarsling, this.prefererteKanaler);

        return innboks;
    }
}
