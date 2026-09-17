@isTest
private class UN_EventMapperTest {
    @isTest
    static void testMapUserNotificationToInnboksEvent() {
        List<UN_Kanal> prefererteKanaler = new List<UN_Kanal>{ UN_Kanal.SMS };
        UN_EksternVarsling eksternVarsling = new UN_EksternVarsling(
            prefererteKanaler,
            'smsText',
            'emailSubject',
            'emailBody',
            true
        );

        UN_InnboksEvent innboksEvent = new UN_InnboksEvent(
            'varselid-12345abcdefghi',
            '12345678901',
            new List<UN_Tekst>{ new UN_Tekst('nb', 'tekst', true) },
            'https://nav.no/link',
            UN_Sensitivitet.HIGH,
            eksternVarsling,
            new UN_Produsent('cluster', 'namespace', 'appnavn')
        );

        UserNotification__c userNotif = new UserNotification__c();

        UN_EventMapper.mapUserNotificationToInnboksEvent(innboksEvent, userNotif);

        Assert.areEqual('INNBOKS', userNotif.INT_Type__c);
        Assert.areEqual(innboksEvent.varselId, userNotif.INT_EventId__c);
        Assert.areEqual(innboksEvent.ident, userNotif.INT_SocialSecurityNumber__c);
        Assert.isTrue(userNotif.INT_Description__c.contains('tekst'));
        Assert.areEqual(innboksEvent.link, userNotif.INT_Link__c);
        Assert.areEqual('high', userNotif.INT_Sensitivity__c);
        Assert.areEqual('SMS', userNotif.INT_Preferred_Channel__c);
        Assert.areEqual('smsText', userNotif.INT_SmsText__c);
        Assert.areEqual('emailSubject', userNotif.INT_EmailSubject__c);
        Assert.areEqual('emailBody', userNotif.INT_EmailBody__c);
        Assert.areEqual('namespace', userNotif.INT_Namespace__c);
        Assert.areEqual('appnavn', userNotif.INT_AppName__c);
        Assert.isTrue(userNotif.INT_Key__c.startsWith('appnavn.namespace.varselid-12345abcdefghi'));
    }

    @isTest
    static void testCreateInnboksEventFromUserNotification() {
        String serTekst = UN_NotificationUtils.serializeTekster(
            new List<UN_Tekst>{ new UN_Tekst('nb', 'Tekst', true) }
        );

        UserNotification__c userNotif = new UserNotification__c(
            INT_Type__c = 'INNBOKS',
            INT_EventId__c = 'eventid-987654321',
            INT_SocialSecurityNumber__c = '10987654321',
            INT_Description__c = serTekst,
            INT_Link__c = 'https://nav.no/event',
            INT_Sensitivity__c = 'high',
            INT_Preferred_Channel__c = UN_Kanal.BETINGET_SMS.name(),
            INT_SmsText__c = 'smsalert',
            INT_EmailSubject__c = 'emne',
            INT_EmailBody__c = 'eposttekst',
            INT_Namespace__c = 'ns',
            INT_AppName__c = 'applikasjon'
        );

        UN_InnboksEvent event = UN_EventMapper.createInnboksEventFromUserNotification(userNotif);

        Assert.areEqual('eventid-987654321', event.varselId);
        Assert.areEqual('10987654321', event.ident);
        Assert.areEqual('https://nav.no/event', event.link);
        Assert.areEqual(UN_Sensitivitet.HIGH, event.sensitivitet);
        Assert.isTrue(event.tekster.size() > 0);
        Assert.areEqual('nb', event.tekster[0].spraakkode);
        Assert.areEqual('ns', event.produsent.namespace);
        Assert.areEqual('applikasjon', event.produsent.appnavn);
        Assert.areEqual('smsalert', event.eksternVarsling.smsVarslingstekst);
        Assert.areEqual('emne', event.eksternVarsling.epostVarslingstittel);
        Assert.areEqual('eposttekst', event.eksternVarsling.epostVarslingstekst);
        Assert.isTrue(
            event.eksternVarsling.prefererteKanaler.size() == 1 &&
            event.eksternVarsling.prefererteKanaler[0] == UN_Kanal.BETINGET_SMS
        );
    }
}
