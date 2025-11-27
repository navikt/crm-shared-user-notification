public inherited sharing class UN_Tekst {
    public String spraakkode = 'no';
    public String tekst = '';
    public Boolean defaultValue = true;

    public UN_Tekst(String spraakkode, String tekst, Boolean defaultValue) {
        this.spraakkode = String.isNotBlank(spraakkode) ? spraakkode : 'no';
        this.tekst = tekst != null ? tekst : '';
        this.defaultValue = defaultValue != null ? defaultValue : true;
    }
}
