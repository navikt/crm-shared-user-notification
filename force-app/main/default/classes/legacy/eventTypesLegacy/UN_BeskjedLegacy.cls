public with sharing class UN_BeskjedLegacy {
    public Long tidspunkt;
    public Long synligFremTil = null;
    public String fodselsnummer;
    public String grupperingsId;
    public String tekst;
    public String link;
    public Integer sikkerhetsnivaa = 4;
    public Boolean eksternVarsling = false;
    public List<UN_PreferertKanal> prefererteKanaler = new List<UN_PreferertKanal>();
}
