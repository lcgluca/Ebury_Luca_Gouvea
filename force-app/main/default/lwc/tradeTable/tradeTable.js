import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';
import TRADE_OBJECT from '@salesforce/schema/Trade__c';
import tradeList from '@salesforce/apex/NewTradeController.getTradeList';

export default class NewTrade extends LightningElement {

    columns = [];
    showOptions = false;
    showWarning = false;
    showTable = false;
    tradeList
    @api openNewTrade = false;
    @track page = 1;
    @track dataTable = [];
    @track items = [];
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @api pageSize = 10;  //pageSize can be defined via DesignAttribute
    @track totalRecountCount = 0;
    @track totalPage = 0;
    isPageChanged = false;
        
    //wires
    @wire(getObjectInfo, { objectApiName: TRADE_OBJECT })
    tradeInfo({ data, error }){
        if(data){
            this.columns = [
                {label: data.fields.Sell_Currency__c.label, fieldName: data.fields.Sell_Currency__c.apiName, type: 'text', cellAttributes:{ alignment: 'left' }},
                {label: data.fields.Sell_Amount__c.label, fieldName:data.fields.Sell_Amount__c.apiName, type: 'number', cellAttributes: { alignment: 'left' }},
                {label: data.fields.Buy_Currency__c.label, fieldName: data.fields.Buy_Currency__c.apiName, type: 'text', cellAttributes: { alignment: 'left' }},
                {label: data.fields.Buy_Amount__c.label, fieldName: data.fields.Buy_Amount__c.apiName, type: 'number', cellAttributes: { alignment: 'left' }},
                {label: data.fields.Rate__c.label, fieldName: data.fields.Rate__c.apiName, type: 'number', cellAttributes: { alignment: 'left' }},
                {label: data.fields.Date_Booked__c.label, fieldName: data.fields.Date_Booked__c.apiName, type: 'date', cellAttributes: { alignment: 'left' }, typeAttributes:{year: "numeric",month: "numeric",day: "2-digit",hour: "2-digit",minute: "2-digit"}}
            ];
            this.showOptions = true;
        }else if(error){
            this.showWarning = true;
        }
    }

    @wire(tradeList)
    tradeListWire(value){
        this.tradeList = value;
        const { data, error } = value;
        if(data){
            if(data.length > 0){
                this.showTable = true;
                this.processRecords(data);
            }
        }
    }

    //handlers
    handleNewTradeButton(){
        this.openNewTrade = true;
    }

    handleNewTrade(){
        this.openNewTrade = false;
        return refreshApex(this.tradeList);
    }

    handleCancel(){
        this.openNewTrade = false;
    }

    processRecords(data){
        this.items = data;
        this.totalRecountCount = data.length; 
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
        
        this.dataTable = this.items.slice(0,this.pageSize); 
        this.endingRecord = this.pageSize;
    }

    previousHandler() {
        this.isPageChanged = true;
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.displayRecordPerPage(this.page);
        }
          var selectedIds = [];
          for(var i=0; i<this.allSelectedRows.length;i++){
            selectedIds.push(this.allSelectedRows[i].Id);
          }
        this.template.querySelector(
            '[data-id="table"]'
          ).selectedRows = selectedIds;
    }

    //clicking on next button this method will be called
    nextHandler() {
        this.isPageChanged = true;
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }
          var selectedIds = [];
          for(var i=0; i<this.allSelectedRows.length;i++){
            selectedIds.push(this.allSelectedRows[i].Id);
          }
        this.template.querySelector(
            '[data-id="table"]'
          ).selectedRows = selectedIds;
    }

    displayRecordPerPage(page){
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.dataTable = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }    
}