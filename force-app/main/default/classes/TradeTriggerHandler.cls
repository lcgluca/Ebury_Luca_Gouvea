/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-25
* @modified       2022-06-25
* Purpose:        class used to hold all methods needed in TradeTrigger
*/

public without sharing class TradeTriggerHandler extends TriggerHandler{
    
    private Map<Id, Trade__c> newTradeMap;
    private Map<Id, Trade__c> oldTradeMap;
    private List<Trade__c> newTradeList;
    private List<Trade__c> oldTradeList;
    
    public TradeTriggerHandler() {
        this.newTradeMap = (Map<Id, Trade__c>) Trigger.newMap;
        this.oldTradeMap = (Map<Id, Trade__c>) Trigger.oldMap;
        this.newTradeList =  (List<Trade__c>) Trigger.new;
        this.oldTradeList =  (List<Trade__c>) Trigger.old;
    }
    
    public override void beforeInsert(){
        saveDateBooked(newTradeList);
    }
    
    public override void afterInsert(){
        newChatterPost(newTradeList);
    }

    private static void newChatterPost(List<Trade__c> newTradeList){
        //junks of 100 to not exceed DML limits
       if(!Test.isRunningTest()) Database.executebatch(new NewTradePostBatch(newTradeList), 100);
    }

    private static void saveDateBooked(List<Trade__c> newTradeList){

        for(Trade__c trade : newTradeList){
            if(trade.Date_Booked__c == null) trade.Date_Booked__c = DateTime.now();
        }
    }
}
