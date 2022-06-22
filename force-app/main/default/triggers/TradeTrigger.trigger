/*
* @author         Luca Gouvea
* @modifiedBy     Luca Gouvea 
* @maintainedBy   Luca Gouvea
* @version        1.0
* @created        2022-06-22
* @modified       2022-06-22
* Purpose:       Trade__c unique trigger
*/

trigger TradeTrigger on Trade__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new TradeTriggerHandler().run(); 
}
  