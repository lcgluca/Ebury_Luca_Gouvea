import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TRADE_OBJECT from '@salesforce/schema/Trade__c';
import SELL_CURRENCY from '@salesforce/schema/Trade__c.Sell_Currency__c';
import SELL_AMOUNT from '@salesforce/schema/Trade__c.Sell_Amount__c';
import BUY_CURRENCY from '@salesforce/schema/Trade__c.Buy_Currency__c';
import BUY_AMOUNT from '@salesforce/schema/Trade__c.Buy_Amount__c';
import RATE from '@salesforce/schema/Trade__c.Rate__c';
import DATE_BOOKED from '@salesforce/schema/Trade__c.Date_Booked__c';
import getCurrentRate from '@salesforce/apex/NewTradeController.getCurrentRate';


export default class NewTradeCreator extends LightningElement {

    sellCurrency = SELL_CURRENCY;
    sellAmount = SELL_AMOUNT;
    buyCurrency = BUY_CURRENCY;
    buyAmount = BUY_AMOUNT;
    rate = RATE;
    bookedDate = DATE_BOOKED;
    runSpinner = false;
    actualRate = 0.0;
    selectedSellCcy;
    selectedBuyCcy;
    selectedSellAmount;
    selectedBuyAmount;

    //getters
    get hasCurrencies() {return !!this.selectedSellCcy && !!this.selectedBuyCcy;}
    get getcalculation() {return this.hasCurrencies && !!this.selectedSellAmount;}
    get disableCreation() {return !(!!this.selectedBuyAmount);}

    //handlers
    handleCurrencyChange(event) {
        if (event.target.name === 'sellCurrency') {
            this.selectedSellCcy = event.detail.value;
        }
        else if (event.target.name === 'buyCurrency') {
            this.selectedBuyCcy = event.detail.value;
        }
        if(this.hasCurrencies){
            this.runSpinner = true;
            this.getRate();
        }         
    }

    handleSellAmount(event){
        this.selectedSellAmount = event.detail.value;
        console.log(this.selectedSellAmount);
        this.calculateBuyAmount();
    }

    handleTradeCreation() {
        const toastSuccess = new ShowToastEvent({
            title: 'Success!',
            message: 'Trade successfully saved.',
            variant: 'success',
            mode: 'pester'
        });
        this.dispatchEvent(toastSuccess);
        this.dispatchEvent(new CustomEvent('tradecreation'));
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancelcreation'));
    }

    //helpers
    getRate(){
        getCurrentRate({base : this.selectedSellCcy, symbol : this.selectedBuyCcy}).
            then(result => {
                this.actualRate = result;
                this.runSpinner = false;
                this.calculateBuyAmount();
                this.template.querySelectorAll('lightning-input-field').forEach(field => {
                    if (field.name === "rate") field.value = result;
                });
            }).catch(error =>{
                this.runSpinner = false;
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                });
                this.dispatchEvent(event);
            });
    }

    calculateBuyAmount(){
        if(this.getcalculation){
            this.selectedBuyAmount = this.actualRate * this.selectedSellAmount;
        }else{
            this.selectedBuyAmount = null;
        }
        this.template.querySelectorAll('lightning-input-field').forEach(field => {
            if (field.name === "buyAmount") field.value = this.selectedBuyAmount;
        });
    }
}