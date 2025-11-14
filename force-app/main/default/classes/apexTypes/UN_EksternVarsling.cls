public inherited sharing class UN_EksternVarsling {
    public List<String> prefererteKanaler;
    public String smsVarslingstekst;
    public String epostVarslingstittel;
    public String epostVarslingstekst;
    public Boolean kanBatches;

    public UN_EksternVarsling(
        List<String> prefererteKanaler,
        String smsVarslingstekst,
        String epostVarslingstittel,
        String epostVarslingstekst,
        Boolean kanBatches
    ) {
        this.prefererteKanaler = prefererteKanaler;
        this.smsVarslingstekst = smsVarslingstekst;
        this.epostVarslingstittel = epostVarslingstittel;
        this.epostVarslingstekst = epostVarslingstekst;
        this.kanBatches = kanBatches;
    }
}
