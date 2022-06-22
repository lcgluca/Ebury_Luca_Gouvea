/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-22
* @modified       2022-06-22
* Purpose: 		  this batch will create a chatter post for each member of Queue regarding new Trades 
*/

global class NewTradePostBatch implements Database.batchable<sObject>, Database.Stateful {

    global List<Trade__c> tradeSet;
    String bodyTemplate;
    
    //Constructor holds the Accounts that need to be updated
    global NewTradePostBatch(List<Trade__c> tradeSet){
        this.tradeSet = tradeSet;
        this.bodyTemplate = [SELECT Id, Body FROM StaticResource WHERE Name = 'NewTradeChatterPost' LIMIT 1].Body.toString();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){    
        Id queueId = [SELECT Id FROM Group WHERE type = 'Queue' AND DeveloperName ='Trade_Reviewers' LIMIT 1].Id;   
        return Database.getQueryLocator([SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:queueId]);       
    }
    
    //Execute will separate Accounts and respective Cases in a map and perform the calculations
    global void execute(Database.BatchableContext BC, List<GroupMember> scope){

        List<FeedItem> feedItemList = new List<FeedItem>();
        
        if(!scope.isEmpty()){      
            for(Trade__c trade : tradeSet){
                String body = buildPostBody(trade, bodyTemplate);

                for(GroupMember member : scope){
                    FeedItem post = new FeedItem();
                    post.Body = body;
                    post.ParentId = member.UserOrGroupId;
                    feedItemList.add(post);
                }
            }

            Database.insert(feedItemList, true);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

    private static String buildPostBody(Trade__c trade, String bodyTemplate){
        String body = bodyTemplate.replace('%%SELL_CURRENCY%%', string.valueOf(trade.Sell_Currency__c));
        body = body.replace('%%SELL_AMOUNT%%', string.valueOf(trade.Sell_Amount__c));
        body = body.replace('%%BUY_CURRENCY%%', string.valueOf(trade.Buy_Currency__c));
        body = body.replace('%%BUY_AMOUNT%%', string.valueOf(trade.Buy_Amount__c));
        body = body.replace('%%RATE%%', string.valueOf(trade.Rate__c));
        body = body.replace('%%DATETIME%%', string.valueOf(trade.Date_Booked__c));
        body = body.replace('%%TRADE_LINK%%', URL.getSalesforceBaseUrl().toExternalForm()+'/'+trade.Id);

        return body;
    }
}