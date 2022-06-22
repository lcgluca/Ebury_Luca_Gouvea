/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-01-25
* @modified       2022-01-27
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
    
    public override void beforeUpdate(){}
    
    public override void beforeInsert(){}
    
    public override void beforeDelete(){}
    
    public override void afterUpdate(){}
    
    public override void afterInsert(){
        newChatterPost(newTradeList);
    }
    
    public override void afterDelete(){}
    
    public override void afterUndelete(){}

    public static void newChatterPost(List<Trade__c> newTradeList){

        Database.executebatch(new NewTradePostBatch(newTradeList));
    }
}