public inherited sharing class UN_EksternVarsling {
    public UN_Kanal preferertKanal = null;
    public String smsVarslingstekst = null;
    public String epostVarslingstittel = null;
    public String epostVarslingstekst = null;
    public Boolean kanBatches = false;

    public UN_EksternVarsling(
        UN_Kanal preferertKanal,
        String smsVarslingstekst,
        String epostVarslingstittel,
        String epostVarslingstekst,
        Boolean kanBatches
    ) {
        this.preferertKanal = preferertKanal;
        this.smsVarslingstekst = smsVarslingstekst;
        this.epostVarslingstittel = epostVarslingstittel;
        this.epostVarslingstekst = epostVarslingstekst;
        this.kanBatches = kanBatches;
    }

    public UN_EksternVarsling(UN_Kanal preferertKanal) {
        this(preferertKanal, null, null, null, false);
    }
}
