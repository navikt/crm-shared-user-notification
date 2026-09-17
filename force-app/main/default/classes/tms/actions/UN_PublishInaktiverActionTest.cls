@isTest
public class UN_PublishInaktiverActionTest {
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
    static void testPublishInaktiverNotification() {
        ApiMock.setTestMock('UN_POST_OPPRETT_VARSEL_EVENT', 200, 'Success');
        Person__c p = [
            SELECT Id, Name, INT_ActorId__c, INT_LastName__c, INT_FirstName__c, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
            LIMIT 1
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
        un.CRM_RelatedSfRecord__c = p.Id;
        un.CRM_SuccessfullySentNotification__c = true;
        insert un;

        un = UN_Util.getUserNotifications(new List<UserNotification__c>{ un })[0];
        UN_EventMapper.mapUserNotificationToInaktiverEvent(new UN_InaktiverEvent(un.INT_EventId__c), un);
        update un;

        Test.startTest();
        UN_PublishInaktiverAction.publishInaktiverNotification(
            UN_Util.getUserNotifications(new List<UserNotification__c>{ un })
        );
        Test.stopTest();

        List<UserNotification__c> notifications = UN_Util.getUserNotifications(new List<UserNotification__c>{ un });

        Assert.areEqual(
            true,
            notifications[0].CRM_SuccessfullySentDone__c,
            'Expected successfully sent Inaktiver event to be true, but got error: ' +
            notifications[0].CRM_NotificationError__c
        );
    }
}
