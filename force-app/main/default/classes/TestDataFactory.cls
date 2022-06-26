public with sharing class TestDataFactory {

    public static User instantiateStandardUser(Boolean isInsert){
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User'];

        User user = new User();
        user.FirstName = 'Test';
        user.LastName = 'Test';
        user.email = 'uniqueTest@anyprovider.com';
        user.username = 'uniqueTest@anyprovider.com';
        user.alias = 'test';
        user.IsActive = true;
        user.ProfileId = standardProfile.Id;
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'Europe/London';
        
        if(isInsert) insert user;

        return user;
    }
    
    public static Trade__c instantiateTrade(Boolean isInsert){
        Trade__c trade = new Trade__c();
        trade.Sell_Amount__c = 10;
        trade.Buy_Amount__c = 5;
        trade.Rate__c = 0.5;
        trade.Sell_Currency__c = 'EUR';
        trade.Buy_Currency__c = 'USD';

        if(isInsert) insert trade;

        return trade;
    }
}


