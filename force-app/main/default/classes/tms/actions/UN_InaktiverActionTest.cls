@isTest
public class UN_InaktiverActionTest {
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
    static void testProduceInaktiverEvents_Success() {
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
        insert un;

        UN_InaktiverAction.Input input = new UN_InaktiverAction.Input();
        input.userNotification = un;

        List<UN_InaktiverAction.Input> inputList = new List<UN_InaktiverAction.Input>{ input };
        Test.startTest();
        List<UN_InaktiverAction.Response> result = UN_InaktiverAction.produceInaktiverEvents(inputList);
        Test.stopTest();

        Assert.areEqual(1, result.size());
        Assert.areEqual(un.CRM_RelatedSfRecord__c, result[0].relatedRecordSfId);
        Assert.isTrue(result[0].success);
        Assert.isNull(result[0].errorMessage);
        Assert.areEqual(un.INT_EventId__c, result[0].userNotification.INT_EventId__c);
    }

    @isTest
    static void testProduceInaktiverEvents_NullInput() {
        UN_InaktiverAction.Input input = new UN_InaktiverAction.Input();
        input.userNotification = null;

        List<UN_InaktiverAction.Input> inputList = new List<UN_InaktiverAction.Input>{ input };
        Test.startTest();
        List<UN_InaktiverAction.Response> result = UN_InaktiverAction.produceInaktiverEvents(inputList);
        Test.stopTest();

        Assert.areEqual(1, result.size());
        Assert.isFalse(result[0].success);
        Assert.isNotNull(result[0].errorMessage);
        Assert.isNull(result[0].relatedRecordSfId);
        Assert.isNull(result[0].userNotification);
    }

    @isTest
    static void testProduceInaktiverEvents_ExceptionOnUpdate() {
        Person__c p = [
            SELECT Id, Name, CRM_Account__c
            FROM Person__c
            WHERE Name = '12345678901'
            LIMIT 1
        ];
        UserNotification__c un = new UserNotification__c();
        un.CRM_Account__c = p.CRM_Account__c;
        un.INT_SocialSecurityNumber__c = p.Name;
        un.INT_Description__c = 'Test notification exception';
        un.INT_Sensitivity__c = 'high';
        un.INT_EventId__c = new Uuid().getValue();
        un.INT_Namespace__c = 'teamcrm';
        un.INT_AppName__c = 'sf-brukernotifikasjon';
        un.INT_Key__c = 'sfbrukernotifikasjonteamcrmevent456';
        un.CRM_RelatedSfRecord__c = p.Id;
        insert un;

        UN_InaktiverAction.Input input = new UN_InaktiverAction.Input();
        input.userNotification = un;

        List<UN_InaktiverAction.Input> inputList = new List<UN_InaktiverAction.Input>{ input };
        Test.startTest();
        List<UN_InaktiverAction.Response> result = UN_InaktiverAction.produceInaktiverEvents(inputList);
        Test.stopTest();

        Assert.areEqual(1, result.size());
        Assert.isTrue(result[0].success);
        Assert.isNull(result[0].errorMessage);
        Assert.areEqual(un.CRM_RelatedSfRecord__c, result[0].relatedRecordSfId);
        Assert.areEqual(un.INT_EventId__c, result[0].userNotification.INT_EventId__c);
    }
}
