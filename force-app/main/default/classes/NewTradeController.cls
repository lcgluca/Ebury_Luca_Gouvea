/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        Controller of "tradeTable" and "newTradeCreator" LWCs
*/

public with sharing class NewTradeController {
    
    @AuraEnabled (cacheable = true)
    public static List<Trade__c> getTradeList(){
            return [SELECT Id,
                Sell_Currency__c,
                Buy_Currency__c,
                Sell_Amount__c,
                Buy_Amount__c,
                Rate__c,
                Date_Booked__c
                FROM Trade__c
                ORDER BY createddate DESC];
    }

    @AuraEnabled
    public static Double getCurrentRate(String base, String symbol){
        try {
            List<String> symbols = new List<String>{symbol};
            GetLatestRateEndpoint.GetLatestRateResponse latestRate = new GetLatestRateEndpoint(base,symbols).execute();
            
            if(latestRate.error != null){
                AuraHandledException ex = new AuraHandledException(latestRate.error.info);
                ex.setMessage(latestRate.error.info);
                throw ex;
            }
            return latestRate.rates[0].rate;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
