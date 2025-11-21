public inherited sharing class UN_Produsent {
    public static final String DEFAULT_CLUSTER =  [SELECT OrganizationType FROM Organization LIMIT 1].OrganizationType == 'Sandbox' ? 'dev-gcp' : 'prod-gcp';
    public static final String DEFAULT_NAMESPACE = 'teamnks';
    public static final String DEFAULT_APPNAVN = 'sf-brukernotifikasjon';

    public String cluster = DEFAULT_CLUSTER;
    public String namespace = DEFAULT_NAMESPACE;
    public String appnavn = DEFAULT_APPNAVN;

    public UN_Produsent(String cluster, String namespace, String appnavn) {
        this.cluster = String.isNotBlank(cluster) ? cluster : DEFAULT_CLUSTER;
        this.namespace = String.isNotBlank(namespace) ? namespace : DEFAULT_NAMESPACE;
        this.appnavn = String.isNotBlank(appnavn) ? appnavn : DEFAULT_APPNAVN;
    }

    public UN_Produsent() {
    }
}
