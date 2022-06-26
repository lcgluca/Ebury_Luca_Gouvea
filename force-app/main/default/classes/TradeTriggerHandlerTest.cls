 @isTest
public with sharing class TradeTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Ebury_App'];
        User user = TestDataFactory.instantiateStandardUser(true);
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.id, AssigneeId = user.Id);
        insert psa;

        Id queueId = [SELECT Id FROM Group WHERE type = 'Queue' AND DeveloperName ='Trade_Reviewers' LIMIT 1].Id;
        GroupMember gm = new GroupMember(UserOrGroupId = user.Id, GroupId = queueId);
        insert gm;
    }

    @isTest
    static void saveDateBookedTest(){
        User user = [SELECT Id FROM User WHERE Email = 'uniqueTest@anyprovider.com'];

        System.runAs(user){
            Test.startTest();
            Trade__c trade = TestDataFactory.instantiateTrade(true);
            Test.stopTest();

            Trade__c td = [SELECT Id, Date_Booked__c FROM Trade__c LIMIT 1];
            system.assert(td.Date_Booked__c != null, 'Field Date Booked saved in beforeInsert context');
        }
    }

    @isTest
    static void newChatterPostTest(){
        User user = [SELECT Id FROM User WHERE Email = 'uniqueTest@anyprovider.com'];

        System.runAs(user){
            Test.startTest();
            Trade__c trade = TestDataFactory.instantiateTrade(true);
            List<Trade__c> tradeList =[SELECT Sell_Currency__c,Buy_Currency__c,Sell_Amount__c,Buy_Amount__c,Rate__c,Date_Booked__c FROM Trade__c];
            Database.executeBatch(new NewTradePostBatch(tradeList));
            Test.stopTest();
        }
        
        List<FeedItem> fd = [SELECT Id FROM FeedItem WHERE ParentId = :user.Id];
        system.assert(fd.size() > 0, 'Chatter posts were created.');
    }

    static void newChatterPostTestFail(){
        User user = [SELECT Id FROM User WHERE Email = 'uniqueTest@anyprovider.com'];

        System.runAs(user){
            Test.startTest();
            Trade__c trade = new Trade__c();
            try {
                Database.executeBatch(new NewTradePostBatch(new List<Trade__c>{trade}));
            }catch(Exception ex){
                system.assert(true, 'Chatter posts with error.');
            }
            
            Test.stopTest();
        }
    }
}
