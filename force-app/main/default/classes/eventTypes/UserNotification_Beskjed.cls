public with sharing class UserNotification_Beskjed {
    public Long tidspunkt;
    public String fodselsnummer;
    public String grupperingsId;

    public Long synligFremTil;
    public String tekst;
    public String link;
    public Integer sikkerhetsnivaa;
    public Boolean eksternVarsling;
    public List<String> prefererteKanaler;
}
