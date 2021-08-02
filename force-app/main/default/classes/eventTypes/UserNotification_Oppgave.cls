public with sharing class UserNotification_Oppgave {
    public Long tidspunkt;
    public String fodselsnummer;
    public String grupperingsId;

    public String tekst;
    public String link;
    public Integer sikkerhetsnivaa;
    public Boolean eksternVarsling;
    public List<String> prefererteKanaler;
}
