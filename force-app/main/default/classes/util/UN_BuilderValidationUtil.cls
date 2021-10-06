public with sharing class UN_BuilderValidationUtil {
    public static final Integer MAX_LENGTH_TEXT_BESKJED = 300;
    public static final Integer MAX_LENGTH_TEXT_OPPGAVE = 500;
    public static final Integer MAX_LENGTH_TEXT_INNBOKS = 500;
    public static final Integer MAX_LENGTH_LINK = 200;
    public static final Integer MAX_LENGTH_GRUPPERINGSID = 100;
    public static final Integer MAX_LENGTH_EVENTID = 50;
    public static final Integer MAX_LENGTH_SYSTEMBRUKER = 100;
    public static final Integer MAX_LENGTH_STATUSINTERN = 100;
    public static final Integer MAX_LENGTH_SAKSTEMA = 50;
    public static final Integer MAX_LENGTH_FODSELSNUMMER = 11;
    public static final Integer MAX_LENGTH_UID = 100;
    public static final Integer MAX_LENGTH_APP_NAME = 100;
    public static final Integer MAX_LENGTH_NAMESPACE = 63;
    public static final boolean IS_REQUIRED_TIDSPUNKT = true;
    public static final boolean IS_REQUIRED_SYNLIGFREMTIL = false;

    public static String validateFodselsnummer(String fodselsnummer) {
        validateNonNullField(fodselsnummer, 'fodselsnummer');
        if (!isPossibleFodselsnummer(fodselsnummer)) {
            throw new FieldValidationException('Field fodselsnummer can only contain numbers, and max length is 11.');
        }
        return fodselsnummer;
    }

    public static Object validateNonNullField(Object field, String fieldName) {
        if (null == field) {
            throw new FieldValidationException(fieldName + ' was null or empty.');
        }
        return field;
    }

    public static String validateNonNullField(String field, String fieldName) {
        if (String.isBlank(field)) {
            throw new FieldValidationException(fieldName + ' was null or empty.');
        }
        return field;
    }

    public static Integer validateSikkerhetsnivaa(Integer sikkerhetsnivaa) {
        if (sikkerhetsnivaa == 3 || sikkerhetsnivaa == 4) {
            return sikkerhetsnivaa;
        } else {
            throw new FieldValidationException('Sikkerhetsnivaa can only be 3 or 4.');
        }
    }

    public static UN_StatusGlobal validateStatusGlobal(UN_StatusGlobal status) {
        validateNonNullField(status, 'statusGlobal');
        if (UN_StatusGlobal.values().contains(status)) {
            return status;
        } else {
            throw new FieldValidationException('Field statusGlobal må matche en av de gyldige globale statusene.');
        }
    }

    public static Boolean isLinkRequired(UN_EventType eventtype) {
        if (UN_EventType.OPPGAVE.equals(eventtype)) {
            return true;
        } else if (
            UN_EventType.BESKJED.equals(eventtype) ||
            UN_EventType.STATUSOPPDATERING.equals(eventtype) ||
            UN_EventType.INNBOKS.equals(eventtype)
        ) {
            return false;
        } else {
            throw new UnknownEventTypeException(
                'We cannot find this event type, and we cannot say is link is mandatory. Check is you are using a legal event type.'
            );
        }
    }

    public static Datetime localDateTimeToUtcTimestamp(Datetime dataAndTime, String fieldName, boolean required) {
        if (dataAndTime != null) {
            return dataAndTime;
        } else {
            if (required) {
                throw new FieldValidationException('Field ' + fieldName + ' kan ikke være null.');
            } else {
                return null;
            }
        }
    }

    public static String validateNonNullFieldMaxLength(String field, String fieldName, Integer maxLength) {
        validateNonNullField(field, fieldName);
        return validateMaxLength(field, fieldName, maxLength);
    }

    public static String validateLinkAndConvertToString(
        String field,
        String fieldName,
        Integer maxLength,
        boolean required
    ) {
        if (required && String.isBlank(field)) {
            throw new FieldValidationException('Field ' + fieldName + ' cannot be blank.');
        } else if (String.isNotBlank(field) && field.length() > maxLength) {
            throw new FieldValidationException(
                'Field ' +
                fieldName +
                ' cannot contain more than ' +
                maxLength +
                ' characters.'
            );
        } else {
            return String.isNotBlank(field) ? field : '';
        }
    }

    public static String validatePrefererteKanaler(boolean eksternVarsling, List<UN_PreferertKanal> field) {
        String fieldName = 'prefererteKanaler';
        String prefererteKanaler = '';
        if (field == null) {
            return null;
        } else if (!eksternVarsling && !field.isEmpty()) {
            throw new FieldValidationException(
                'Field ' +
                fieldName +
                ' cannot be set as long as eksternVarsling is set to false.'
            );
        } else if (field != null && field.isEmpty() != true) {
            for (UN_PreferertKanal preferertKanal : field) {
                prefererteKanaler += preferertKanal.name() + ',';
            }
            prefererteKanaler.removeEnd(',');
            return prefererteKanaler;
        } else {
            return null;
        }
    }

    public static String validateEventId(String eventId) {
        validateNonNullFieldMaxLength(eventId, 'eventId', MAX_LENGTH_EVENTID);
        if (false == Uuid.isValid(eventId)) {
            throw new FieldValidationException('Field eventId is not a valid uuid.');
        }
        return eventId;
    }

    static boolean isPossibleFodselsnummer(String field) {
        if (isCorrectLengthForFodselsnummer(field)) {
            return field.isNumeric();
        } else {
            return false;
        }
    }

    private static boolean isCorrectLengthForFodselsnummer(String field) {
        return field.length() == MAX_LENGTH_FODSELSNUMMER;
    }

    private static String validateMaxLength(String field, String fieldName, Integer maxLength) {
        if (field.length() > maxLength) {
            throw new FieldValidationException(
                'Field ' +
                fieldName +
                ' cannot contain more than ' +
                maxLength +
                ' characters.'
            );
        }
        return field;
    }

    public class FieldValidationException extends Exception {
    }

    public class UnknownEventTypeException extends Exception {
    }
}
