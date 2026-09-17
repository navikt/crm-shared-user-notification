public inherited sharing class UN_InnboksEvent extends UN_OpprettVarselEvent {
    public UN_InnboksEvent(
        String varselId,
        String ident,
        List<UN_Tekst> tekster,
        String link,
        UN_Sensitivitet sensitivitet,
        UN_EksternVarsling eksternVarsling,
        UN_Produsent produsent
    ) {
        super(UN_Type.INNBOKS, varselId, ident, tekster, link, sensitivitet, null, eksternVarsling, produsent);
    }
}
