import { LightningElement, track, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
//import { refreshApex } from '@salesforce/apex';
//import { deleteRecord } from 'lightning/uiRecordApi';
import getAllSubTodos from '@salesforce/apex/TodoController.getAllSubTodos';
//import { reduceErrors } from 'c/ldsUtils';

import todoResources from '@salesforce/resourceUrl/todo_app';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import TODO__C_OBJECT from '@salesforce/schema/Todo__c';
import NAME_FIELD from '@salesforce/schema/Todo__c.Name';
import SUB_TODO__C_OBJECT from '@salesforce/schema/Sub_Todo__c';
import SUB_TODO_NAME_FIELD from '@salesforce/schema/Sub_Todo__c.Name';
import SUB_STATUS__C_FIELD from '@salesforce/schema/Sub_Todo__c.Status__c';
import TODO_FIELD from '@salesforce/schema/Sub_Todo__c.Todo__c';
import DESCRIPTION__C_FIELD from '@salesforce/schema/Todo__c.Description__c';
import CATEGORY__C_FIELD from '@salesforce/schema/Todo__c.Category__c';
import STATUS__C_FIELD from '@salesforce/schema/Todo__c.Status__c';
import PRIORITY__C_FIELD from '@salesforce/schema/Todo__c.Priority__c';

export default class TodoTile extends LightningElement {
 
    header = 'Edit record';
   // fields = [NAME_FIELD, DESCRIPTION__C_FIELD, CATEGORY__C_FIELD, PRIORITY__C_FIELD, STATUS__C_FIELD];
    @api name = NAME_FIELD;
    @api description = DESCRIPTION__C_FIELD;
    @api category = CATEGORY__C_FIELD;
    @api priority = PRIORITY__C_FIELD;
    @api status =  STATUS__C_FIELD;
    @api objectApiName = TODO__C_OBJECT;
  //  @api recordId = TODO__C_OBJECT.Id;
    @api todo;
   // @api recordId='a098c00000sinAdAAI';
    // @wire(getRecord,{recordId:this.todo.Id})
    // wireRecord({data,error}){
    
    //     if(data){
    //       //  this.todo = data;
    //         getAllSubTodos({recordId:this.data.Id})
    //         .then(result => {
    //             this.subtodos = result;
    //         })
    //         .catch(error => {
    //             this.error = error;
    //         });
            

    //     }else{
        
    //     this.error = error;
    //     this.data=undefined;
    //     }
        
    //     }
    @wire(getAllSubTodos,{recordId:this.todo.Id})
    wireRecord({data,error}){
    
        if(data){
            this.subtodos = data;
           // getAllSubTodos({recordId:this.data.Id})
           
        }else{
        
        this.error = error;
        this.data=undefined;
        }
        
        }
     FIELDS = [
        'Sub_Todo__c.Name',
        'Sub_Todo__c.Status__c',
        'Sub_Todo__c.Todo__c',
    ];
    

    // @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    // subtodo;
    // get subtodo_name() {
    //     return this.subtodo.data.fields.Name.value;
    // }

    // get subtodo_status() {
    //     return this.subtodo.data.fields.Status__c.value;
    // }

    // get subtodo_parent() {
    //     return this.subtodo.data.fields.Todo__c.value;
    // }

    @track subtodos;
    @track dataNotFound;
    //@wire(getAllSubTodos,{recordId: this.todo.Id})
    
    // wireRecord({data,error}){
    
    // if(data){
        
    // this.subtodos = data;
    // this.error = undefined;
    // this.dataNotFound = '';
    // if(this.subtodos == ''){
    // this.dataNotFound = 'There is not Subs found related to Todo name';   
    // }
    
    // }else{
    
    // this.error = error;
    // this.data=undefined;
    // }
    
    // }
	appResources = {
		todoSilhouette: `${todoResources}/todo_app/img/to-do-list.png`,
	};
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('todoview', {
            detail: this.todo.Id
        });
        this.dispatchEvent(selectEvent);
    }

    handleDeleteTodo() {
       
        const deleteEvent = new CustomEvent('deleted', {
            detail: this.todo.Id
        });
        this.dispatchEvent(deleteEvent);
            
    }

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "to-do record updated",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);  

        const updateEvent = new CustomEvent('updated', {
            detail: this.todo.Id
        });
        this.dispatchEvent(updateEvent);
    }

    handleShowModal() {
        const modal = this.template.querySelector('c-modal');
        modal.show();
    }

    handleCancelModal() {
        const modal = this.template.querySelector('c-modal');
        modal.hide();
    }

    /*-------STYLING-------------------------------------------------------*/
    @api
    get categoryStyle() { 
        return this.todo.Category__c == 'Today'? "slds-badge slds-theme_error":
        (this.todo.Category__c == 
            'Tomorrow'?"slds-badge slds-theme_warning":
            "slds-badge slds-theme_success"); 
    }

    
  

}