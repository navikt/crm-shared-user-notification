public with sharing class UN_Util {
    private static Set<String> SF_SYSTEM_USERS = new Set<String>{ 'teamnks' };

    public static DateTime longTimeToDateTime(Long milliseconds) {
        return milliseconds == null ? null : DateTime.newInstance(milliseconds);
    }

    public static Long dateTimeToLong(DateTime dt) {
        return dt == null ? null : dt.getTime();
    }

    public static String listToMultiSelect(List<String> stringList) {
        return stringList != null && stringList.size() > 0 ? String.join(stringList, ';') : null;
    }

    public static List<String> multiSelectToList(String multiSelect) {
        return String.isNotBlank(multiSelect) ? multiSelect.split(';') : new List<String>();
    }

    public static Boolean isSfMessage(UserNotification__c notification) {
        return SF_SYSTEM_USERS.contains(notification.INT_SystemUser__c);
    }

    public static Boolean isUnpublishedMessage(UserNotification__c notification) {
        return isSfMessage(notification) && null == notification.INT_LastUpdatedFromKafka__c;
    }

    public static String createErrorMessage(Exception e) {
        return e.getTypeName() + ': ' + e.getMessage() + ' Stack trace: ' + e.getStackTraceString();
    }

    public static void setKey(UserNotification__c notification) {
        notification.INT_Key__c = createKey(notification.INT_SystemUser__c, notification.INT_EventId__c);
    }

    public static String createKey(String systemUser, String eventId) {
        return systemUser + eventId;
    }

    public static void setEventId(UserNotification__c notification) {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid =
            h.SubString(0, 8) +
            '-' +
            h.SubString(8, 12) +
            '-' +
            h.SubString(12, 16) +
            '-' +
            h.SubString(16, 20) +
            '-' +
            h.substring(20);

        notification.INT_EventId__c = guid;
    }

    public static Map<String, UN_PreferertKanal> getPreferertKanalStringMap() {
        return new Map<String, UN_PreferertKanal>{
            UN_PreferertKanal.SMS.name() => UN_PreferertKanal.SMS,
            UN_PreferertKanal.EPOST.name() => UN_PreferertKanal.EPOST
        };
    }

    public static List<UN_PreferertKanal> stringListToPreferertKanalList(List<String> stringList) {
        List<UN_PreferertKanal> pkList;
        if (stringList != null && false == stringList.isEmpty()) {
            Map<String, UN_PreferertKanal> pkMap = getPreferertKanalStringMap();

            pkList = new List<UN_PreferertKanal>();

            for (String name : stringList) {
                if (pkMap.containsKey(name.toUpperCase())) {
                    pkList.add(pkMap.get(name.toUpperCase()));
                }
            }
        }

        return pkList;
    }
}
