import { LightningElement, api, wire } from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TODO__C_OBJECT from '@salesforce/schema/Todo__c';
import NAME_FIELD from '@salesforce/schema/Sub_Todo__c.Name';
import SUB_TODO__C_OBJECT from '@salesforce/schema/Sub_Todo__c';
import STATUS__C_FIELD from '@salesforce/schema/Sub_Todo__c.Status__c';

export default class SubTodo extends LightningElement {
 
//     header = 'Edit record';
//    // fields = [NAME_FIELD, DESCRIPTION__C_FIELD, CATEGORY__C_FIELD, PRIORITY__C_FIELD, STATUS__C_FIELD];
//     @api name = NAME_FIELD;
 
//     @api status =  STATUS__C_FIELD;
//     @api objectApiName = SUB_TODO__C_OBJECT;
//     @api recordId = SUB_TODO__C_OBJECT.Id;
   @api subtodo;
   
//     @api subtodos;
//     @wire(getRecord)subtodo;


}