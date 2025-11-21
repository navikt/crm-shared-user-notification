public inherited sharing class UN_EksternVarsling {
    public List<UN_Kanal> prefererteKanaler = null;
    public String smsVarslingstekst = null;
    public String epostVarslingstittel = null;
    public String epostVarslingstekst = null;
    public Boolean kanBatches = false;

    public UN_EksternVarsling(
        List<UN_Kanal> prefererteKanaler,
        String smsVarslingstekst,
        String epostVarslingstittel,
        String epostVarslingstekst,
        Boolean kanBatches
    ) {
        this.prefererteKanaler = prefererteKanaler;
        this.smsVarslingstekst = smsVarslingstekst;
        this.epostVarslingstittel = epostVarslingstittel;
        this.epostVarslingstekst = epostVarslingstekst;
        this.kanBatches = (kanBatches == null) ? false : kanBatches;
    }

    public UN_EksternVarsling(List<UN_Kanal> prefererteKanaler) {
        this(prefererteKanaler, null, null, null, false);
    }
}
