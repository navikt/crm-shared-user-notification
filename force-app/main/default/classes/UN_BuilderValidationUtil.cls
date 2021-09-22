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
    public static final boolean IS_REQUIRED_TIDSPUNKT = true;
    public static final boolean IS_REQUIRED_SYNLIGFREMTIL = false;

    public static String validateFodselsnummer(String fodselsnummer) {
        validateNonNullField(fodselsnummer, 'fodselsnummer');
        if (!isPossibleFodselsnummer(fodselsnummer)) {
            throw new FieldValidationException('Field fodselsnummer can only contain numbers, and max length is 11.');
        }
        return fodselsnummer;
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

    public static boolean isLinkRequired(String eventtype) {
        if ('OPPGAVE' == eventtype) {
            return true;
        } else if ('BESKJED' == eventtype || 'STATUSOPPDATERING' == eventtype || 'INNBOKS' == eventtype) {
            return false;
        } else {
            throw new UnknownEventtypeException(
                'We cannot find this event type, and we cannot say is link is mandatory. Check is you are using a legal event type.'
            );
        }
    }

    public static Long localDateTimeToUtcTimestamp(Datetime dataAndTime, String fieldName, boolean required) {
        if (dataAndTime != null) {
            return dataAndTime.getTime();
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

    public static List<String> validatePrefererteKanaler(boolean eksternVarsling, List<String> field) {
        String fieldName = 'prefererteKanaler';
        if (field == null) {
            return null;
        } else if (!eksternVarsling && !field.isEmpty()) {
            throw new FieldValidationException(
                'Field ' +
                fieldName +
                ' cannot be set as long as eksternVarsling is set to false.'
            );
        } else if (field != null) {
            return field;
        } else {
            return null;
        }
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

    public class UnknownEventtypeException extends Exception {
    }
}
