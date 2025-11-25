@isTest
public class UN_PublishInnboksActionTest {
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
    static void testPublishInnboksNotification() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'OK');
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
        ];
        UserNotification__c un = new UserNotification__c();
        un.CRM_Account__c = p.CRM_Account__c;
        un.INT_SocialSecurityNumber__c = p.Name;
        un.INT_Description__c = 'Test notification';
        un.INT_Sensitivity__c = 'high';
        un.INT_EventId__c = new Uuid().getValue();
        un.INT_Namespace__c = 'teamcrm';
        un.INT_AppName__c = 'sf-brukernotifikasjon';
        un.INT_Key__c = 'sfbrukernotifikasjonteamcrmevent123';
        insert un;

        List<UserNotification__c> inputList = new List<UserNotification__c>{ un };

        Test.startTest();
        List<UserNotification__c> result = UN_PublishInnboksNotificationAction.publishInnboksNotification(
            UN_Util.getUserNotifications(inputList)
        );
        Test.stopTest();

        List<UserNotification__c> notifications = UN_Util.getUserNotifications(inputList);
        Assert.areEqual(
            true,
            notifications[0].CRM_SuccessfullySentNotification__c,
            'Expected successfully sent, but got error: ' + notifications[0].CRM_NotificationError__c
        );
        Assert.areEqual(1, result.size());
        Assert.areEqual(un.Id, result[0].Id);
    }
}
