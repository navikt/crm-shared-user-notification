public virtual inherited sharing class UN_OpprettVarselEvent {
    public String type;
    public String varselId;
    public String ident;
    public List<UN_Tekst> tekster;
    public String link;
    public String sensitivitet;
    public String aktivFremTil;
    public UN_EksternVarsling eksternVarsling;
    public UN_Produsent produsent;

    public UN_OpprettVarselEvent(
        String type,
        String varselId,
        String ident,
        List<UN_Tekst> tekster,
        String link,
        String sensitivitet,
        String aktivFremTil,
        UN_EksternVarsling eksternVarsling,
        UN_Produsent produsent
    ) {
        this.type = type;
        this.varselId = varselId;
        this.ident = ident;
        this.tekster = tekster;
        this.link = link;
        this.sensitivitet = sensitivitet;
        this.aktivFremTil = aktivFremTil;
        this.eksternVarsling = eksternVarsling;
        this.produsent = produsent;
    }
}
