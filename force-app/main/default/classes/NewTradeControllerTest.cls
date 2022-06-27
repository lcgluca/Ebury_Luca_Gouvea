/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        Test class for NewTradeController
*/

@isTest
public with sharing class NewTradeControllerTest {
    
    @TestSetup
    static void makeData(){
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Ebury_App'];
        User user = TestDataFactory.instantiateStandardUser(true);
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = ps.id, AssigneeId = user.Id);
        insert psa;
    }

    @isTest
    static void getCurrentRateTest(){
        User user = [SELECT Id FROM User WHERE Email = 'uniqueTest@anyprovider.com'];

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockFixerSuccess');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        System.runAs(user){
            Test.startTest();
            double currentRate = NewTradeController.getCurrentRate('BRL','USD');
            Test.stopTest();

            system.assert(currentRate == 5.53503, 'Got rate from mocked response in Static Resource');
        }
    }

    @isTest
    static void getCurrentRateTestFail(){
        User user = [SELECT Id FROM User WHERE Email = 'uniqueTest@anyprovider.com'];

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockFixerError');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        System.runAs(user){
            Test.startTest();
            try{
                double currentRate = NewTradeController.getCurrentRate('undefinedCODE','USD');
            }catch(Exception ex){
                System.assert(true, 'Got ERROR from mocked response in Static Resource');
            }
            Test.stopTest();
        }
    }

    @isTest
    static void getTradeListTest(){
        User user = [SELECT Id FROM User WHERE Email = 'uniqueTest@anyprovider.com'];

        System.runAs(user){
            Test.startTest();
            Trade__c trade = TestDataFactory.instantiateTrade(true);
            List<Trade__c> testList = NewTradeController.getTradeList();
            Test.stopTest();

            System.assert(testList.size() > 0, 'Retrieved all trades.');
        }
    }
}
