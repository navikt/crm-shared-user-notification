public with sharing class UserNotification_Util {
    public static DateTime longTimeToDateTime(Long milliseconds) {
        return milliseconds == null ? null : DateTime.newInstance(milliseconds);
    }

    public static Long dateTimeToLong(DateTime dt) {
        return dt == null ? null : dt.getTime();
    }

    public static String listToMultiSelect(List<String> stringList) {
        return stringList != null && stringList.size() > 0 ? String.join(stringList,';') : null;
    }

    public static List<String> multiSelectToList(String multiSelect) {
        return String.isNotBlank(multiSelect) ? multiSelect.split(';') : new List<String>();
    }
}
