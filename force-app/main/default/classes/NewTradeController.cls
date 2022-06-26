public with sharing class NewTradeController {
    
    @AuraEnabled (cacheable = true)
    public static List<Trade__c> getTradeList(){
        try {
            return [SELECT Id,
                Sell_Currency__c,
                Buy_Currency__c,
                Sell_Amount__c,
                Buy_Amount__c,
                Rate__c,
                Date_Booked__c
                FROM Trade__c
                ORDER BY createddate DESC];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Double getCurrentRate(String base, String symbol){
        try {
            List<String> symbols = new List<String>{symbol};
            GetLatestRateEndpoint.GetLatestRateResponse latestRate = new GetLatestRateEndpoint(base,symbols).execute();

            return latestRate.rates[0].rate;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}