public inherited sharing class UN_NotificationUtils {
    public static Boolean typeIsValid(String val) {
        if (String.isBlank(val))
            return false;
        for (UN_Type ev : UN_Type.values())
            if (ev.name().equalsIgnoreCase(val.trim()))
                return true;
        return false;
    }

    public static Boolean kanalIsValid(String val) {
        if (String.isBlank(val))
            return false;
        for (UN_Kanal c : UN_Kanal.values())
            if (c.name().equalsIgnoreCase(val.trim()))
                return true;
        return false;
    }

    public static Boolean sensitivitetIsValid(String val) {
        if (String.isBlank(val))
            return false;
        for (UN_Sensitivitet s : UN_Sensitivitet.values())
            if (s.name().equalsIgnoreCase(val.trim()))
                return true;
        return false;
    }

    public static Boolean isValidISO8601(String val) {
        if (String.isBlank(val))
            return false;
        try {
            DateTime dt = DateTime.valueOf(val);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static UN_Sensitivitet fromString(String val) {
        if (String.isBlank(val))
            return null;
        for (UN_Sensitivitet s : UN_Sensitivitet.values())
            if (s.name().equalsIgnoreCase(val.trim()))
                return s;
        return null;
    }

    public static List<UN_Tekst> parseTekster(String description) {
        List<UN_Tekst> tekster = new List<UN_Tekst>();
        if (String.isBlank(description))
            return tekster;
        description = description.trim();
        if (description.startsWith('[')) {
            try {
                List<Object> items = (List<Object>) JSON.deserializeUntyped(description);
                for (Object itemObj : items) {
                    Map<String, Object> item = (Map<String, Object>) itemObj;
                    String spraakkode = (String) item.get('spraakkode');
                    String tekst = (String) item.get('tekst');
                    Boolean isDefault = item.containsKey('default') ? (Boolean) item.get('default') : false;
                    tekster.add(new UN_Tekst(spraakkode, tekst, isDefault));
                }
            } catch (Exception e) {
                tekster = fallbackSplitTekst(description);
            }
        } else {
            tekster = fallbackSplitTekst(description);
        }
        return tekster;
    }

    private static List<UN_Tekst> fallbackSplitTekst(String txt) {
        List<UN_Tekst> tekster = new List<UN_Tekst>();
        for (Integer i = 0; i < txt.split(';').size(); i++)
            tekster.add(new UN_Tekst('no', txt.split(';')[i].trim(), i == 0));
        return tekster;
    }

    public static String serializeTekster(List<UN_Tekst> tekster) {
        if (tekster == null || tekster.isEmpty())
            return '';
        Boolean useJson = tekster.size() > 1;
        if (!useJson)
            for (UN_Tekst t : tekster)
                if (t.spraakkode != 'no')
                    useJson = true;
        if (useJson) {
            List<Map<String, Object>> tekstObjects = new List<Map<String, Object>>();
            for (UN_Tekst t : tekster)
                tekstObjects.add(
                    new Map<String, Object>{
                        'spraakkode' => t.spraakkode,
                        'tekst' => t.tekst,
                        'default' => t.defaultValue
                    }
                );
            return JSON.serialize(tekstObjects);
        } else {
            List<String> tekstValues = new List<String>();
            for (UN_Tekst t : tekster)
                tekstValues.add(t.tekst);
            return String.join(tekstValues, ';');
        }
    }

    public static List<UN_Kanal> parseKanalString(String kanalString) {
        List<UN_Kanal> values = new List<UN_Kanal>();
        if (!String.isBlank(kanalString)) {
            for (String s : kanalString.split(';|,')) {
                String v = s.trim().toUpperCase();
                if (kanalIsValid(v))
                    values.add(UN_Kanal.valueOf(v));
            }
        }
        return values;
    }

    public static String kanalerToString(List<UN_Kanal> kanaler) {
        List<String> out = new List<String>();
        for (UN_Kanal c : kanaler)
            out.add(c.name());
        return String.join(out, ';');
    }

    public static void removeNulls(Map<String, Object> m) {
        List<String> toRemove = new List<String>();
        for (String k : m.keySet()) {
            if (m.get(k) == null) {
                toRemove.add(k);
            }
        }
        for (String k : toRemove) {
            m.remove(k);
        }
    }
}
