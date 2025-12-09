@isTest
public class UN_InnboksActionTest {
    @TestSetup
    static void makeData() {
        Person__c person = (Person__c) UN_TestDataFactory.createRecord(
            new Person__c(
                Name = '12345678901',
                INT_ActorId__c = '9876543210',
                INT_LastName__c = 'LastName',
                INT_FirstName__c = 'FirstName'
            ),
            true
        );
    }

    @isTest
    static void testProduceInnboksNotification_Success() {
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];

        UN_InnboksAction.Input input = new UN_InnboksAction.Input();
        input.ident = p.Name;
        input.tekster = '[{"spraakkode":"nb","tekst":"Test notification"}]';
        input.link = 'https://example.com';
        input.sensitivitet = 'HIGH';
        input.preferertKanal = 'SMS';
        input.accountId = p.CRM_Account__c;
        input.relatedRecordSfId = p.CRM_Account__c;
        input.smsVarslingstekst = 'Test SMS';
        input.epostVarslingstittel = 'Test Title';
        input.epostVarslingstekst = 'Test Email';
        input.kanBatches = false;
        input.cluster = 'TestCluster';
        input.namespace = 'teamcrm';
        input.appnavn = 'sf-brukernotifikasjon';

        List<UN_InnboksAction.Input> inputs = new List<UN_InnboksAction.Input>{ input };

        Test.startTest();
        List<UN_InnboksAction.Response> results = UN_InnboksAction.produceInnboksNotification(inputs);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        UN_InnboksAction.Response resp = results[0];
        Assert.areEqual(p.CRM_Account__c, resp.userNotification.CRM_Account__c);
        Assert.areEqual(true, resp.success);
        Assert.isTrue(resp.errorMessage == null);
        List<UserNotification__c> notifications = UN_Util.getUserNotifications(new Set<Id>{ resp.userNotification.Id });
        Assert.areEqual(1, notifications.size());
        Assert.areEqual(
            true,
            String.isBlank(notifications[0].CRM_NotificationError__c),
            'Expected blank, not ' + notifications[0].CRM_NotificationError__c
        );
        Assert.areEqual(UN_Kanal.SMS.name(), notifications[0].INT_Preferred_Channel__c);
    }

    @isTest
    static void testProduceInnboksNotification_Failure() {
        UN_InnboksAction.Input input = new UN_InnboksAction.Input();
        input.ident = '11223344556';
        input.tekster = '[{"spraakkode":"nb","tekst":"Fail notification"}]';
        input.link = null;
        input.sensitivitet = null;
        input.preferertKanal = 'EPOST';
        input.accountId = null;
        input.relatedRecordSfId = null;

        List<UN_InnboksAction.Input> inputs = new List<UN_InnboksAction.Input>{ input };

        Test.startTest();
        List<UN_InnboksAction.Response> results = UN_InnboksAction.produceInnboksNotification(inputs);
        Test.stopTest();

        Assert.areEqual(1, results.size());
        UN_InnboksAction.Response resp = results[0];
        Assert.areEqual(false, resp.success);
        Assert.areNotEqual(null, resp.errorMessage);
    }
}
