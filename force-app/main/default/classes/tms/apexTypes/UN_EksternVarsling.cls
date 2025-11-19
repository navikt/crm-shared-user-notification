public inherited sharing class UN_EksternVarsling {
    public List<UN_Kanal> prefererteKanaler = new List<UN_Kanal>();
    public String smsVarslingstekst = '';
    public String epostVarslingstittel = '';
    public String epostVarslingstekst = '';
    public Boolean kanBatches = false; // sjekk om varslingen kan batches

    public UN_EksternVarsling(
        List<UN_Kanal> prefererteKanaler,
        String smsVarslingstekst,
        String epostVarslingstittel,
        String epostVarslingstekst,
        Boolean kanBatches
    ) {
        this.prefererteKanaler = prefererteKanaler != null ? prefererteKanaler : new List<UN_Kanal>();
        this.smsVarslingstekst = smsVarslingstekst != null ? smsVarslingstekst : '';
        this.epostVarslingstittel = epostVarslingstittel != null ? epostVarslingstittel : '';
        this.epostVarslingstekst = epostVarslingstekst != null ? epostVarslingstekst : '';
        this.kanBatches = kanBatches != null ? kanBatches : false;
    }

    public UN_EksternVarsling(List<UN_Kanal> prefererteKanaler) {
        this(prefererteKanaler, null, null, null, false);
    }
}
