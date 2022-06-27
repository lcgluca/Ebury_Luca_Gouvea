/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-22
* @modified       2022-06-22
* Purpose: 		  This batch will create a chatter post for each member of Queue regarding new Trades 
*/

public class NewTradePostBatch implements Database.batchable<sObject>, Database.Stateful {

    public List<Trade__c> tradeSet;
    String bodyTemplate;
    
    //Constructor holds the Trades in case of multiple insertion
    public NewTradePostBatch(List<Trade__c> tradeSet){
        this.tradeSet = tradeSet;
        this.bodyTemplate = [SELECT Id, Body FROM StaticResource WHERE Name = 'NewTradeChatterPost' LIMIT 1].Body.toString();
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){    
        Id queueId = [SELECT Id FROM Group WHERE type = 'Queue' AND DeveloperName ='Trade_Reviewers' LIMIT 1].Id;   
        return Database.getQueryLocator([SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:queueId]);       
    }
    
    //Execute will create the message for every Trade and then create a Chatter post for every queue member
    public void execute(Database.BatchableContext BC, List<GroupMember> scope){

        try{
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

                Database.SaveResult[] srList = Database.insert(feedItemList, false);
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        }
                    }
                }
            }

        }catch(Exception ex){
            throw new NewTradeBatchException('Error on chatter posts creation');
        }
    }
    
    public void finish(Database.BatchableContext BC){
        //Treatment of errors could be here
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

    public class NewTradeBatchException extends Exception {}
}