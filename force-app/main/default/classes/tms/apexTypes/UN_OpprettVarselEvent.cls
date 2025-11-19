public virtual inherited sharing class UN_OpprettVarselEvent {
    public UN_Type type;
    public String varselId;
    public String ident;
    public List<UN_Tekst> tekster = new List<UN_Tekst>();
    public String link;
    public UN_Sensitivitet sensitivitet;
    public String aktivFremTil;
    public UN_EksternVarsling eksternVarsling;
    public UN_Produsent produsent;

    public UN_OpprettVarselEvent(
        UN_Type type,
        String varselId,
        String ident,
        List<UN_Tekst> tekster,
        String link,
        UN_Sensitivitet sensitivitet,
        String aktivFremTil,
        UN_EksternVarsling eksternVarsling,
        UN_Produsent produsent
    ) {
        this.type = type;
        this.varselId = varselId;
        this.ident = ident;
        this.tekster = tekster != null ? tekster : new List<UN_Tekst>();
        this.link = link;
        this.sensitivitet = sensitivitet;
        this.aktivFremTil = aktivFremTil;
        this.eksternVarsling = eksternVarsling;
        this.produsent = produsent;
    }

    public void validate() {
        if (type == null)
            throw new OpprettVarselValidationException('type is required');
        if (String.isBlank(varselId) || !Pattern.matches('^[A-Za-z0-9\\-]{16,36}$', varselId))
            throw new OpprettVarselValidationException('varselId must be valid UUID or ULID');
        if (String.isBlank(ident) || !Pattern.matches('^\\d{11}$', ident))
            throw new OpprettVarselValidationException('ident must be exactly 11 digits');
        if (tekster == null || tekster.isEmpty())
            throw new OpprettVarselValidationException('tekster must have at least one entry');
        for (UN_Tekst t : tekster)
            if (String.isBlank(t.spraakkode) || !Pattern.matches('^[a-z]{2,3}$|^nb-\\d+$', t.spraakkode))
                throw new OpprettVarselValidationException('tekster has invalid language code');
        if (!String.isBlank(link) && !Pattern.matches('^https?://.+', link))
            throw new OpprettVarselValidationException('link must be complete URL');
        if (sensitivitet == null)
            throw new OpprettVarselValidationException('sensitivitet is required');
        if (
            !String.isBlank(aktivFremTil) &&
            !UN_NotificationUtils.isValidISO8601(aktivFremTil) &&
            !Pattern.matches('^\\d+$', aktivFremTil)
        )
            throw new OpprettVarselValidationException('aktivFremTil invalid format');
        if (eksternVarsling != null && eksternVarsling.prefererteKanaler != null)
            for (UN_Kanal k : eksternVarsling.prefererteKanaler)
                if (k == null)
                    throw new OpprettVarselValidationException('eksternVarsling channel not supported');
        if (
            produsent == null ||
            String.isBlank(produsent.cluster) ||
            String.isBlank(produsent.namespace) ||
            String.isBlank(produsent.appnavn)
        )
            throw new OpprettVarselValidationException('produsent fields required');
    }
    public class OpprettVarselValidationException extends Exception {
    }
}
