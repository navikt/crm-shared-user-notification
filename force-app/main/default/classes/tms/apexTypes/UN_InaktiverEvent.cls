public inherited sharing class UN_InaktiverEvent {
    public String varselId;
    public UN_Produsent produsent;

    public UN_InaktiverEvent(String varselId, UN_Produsent produsent) {
        this.varselId = varselId;
        this.produsent = produsent;
    }

    public UN_InaktiverEvent(String varselId) {
        this.varselId = varselId;
        this.produsent = new UN_Produsent(
            UN_Produsent.DEFAULT_CLUSTER,
            UN_Produsent.DEFAULT_NAMESPACE,
            UN_Produsent.DEFAULT_APPNAVN
        );
    }

    public void validate() {
        if (String.isBlank(varselId) || !Pattern.matches('^[A-Za-z0-9\\-]{16,36}$', varselId))
            throw new InaktiverVarselValidationException('varselId must be valid UUID or ULID');
        if (
            produsent == null ||
            String.isBlank(produsent.cluster) ||
            String.isBlank(produsent.namespace) ||
            String.isBlank(produsent.appnavn)
        )
            throw new InaktiverVarselValidationException('produsent fields required');
    }

    public class InaktiverVarselValidationException extends Exception {
    }
}
