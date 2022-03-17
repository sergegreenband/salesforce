import { LightningElement, api, wire } from 'lwc';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import getAllTodos from '@salesforce/apex/TodoController.getAllTodos';
import { reduceErrors } from 'c/ldsUtils';

import todoResources from '@salesforce/resourceUrl/todo_app';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import TODO__C_OBJECT from '@salesforce/schema/Todo__c';
import NAME_FIELD from '@salesforce/schema/Todo__c.Name';
import DESCRIPTION__C_FIELD from '@salesforce/schema/Todo__c.Description__c';
import CATEGORY__C_FIELD from '@salesforce/schema/Todo__c.Category__c';
import STATUS__C_FIELD from '@salesforce/schema/Todo__c.Status__c';
import PRIORITY__C_FIELD from '@salesforce/schema/Todo__c.Priority__c';

export default class TodoTile extends LightningElement {
 
    header = 'Edit record';
   // fields = [NAME_FIELD, DESCRIPTION__C_FIELD, CATEGORY__C_FIELD, PRIORITY__C_FIELD, STATUS__C_FIELD];
    @api  name = NAME_FIELD;
    @api description = DESCRIPTION__C_FIELD;
    @api category = CATEGORY__C_FIELD;
    @api priority = PRIORITY__C_FIELD;
    @api status =  STATUS__C_FIELD;
    @api objectApiName = TODO__C_OBJECT;
    @api recordId = TODO__C_OBJECT.Id;
    @api todo;
    @wire(getRecord)todo;
    todos;
    error;
    wiredTodosResult;
    

    @wire(getAllTodos)
    wiredTodos(result) {
        this.wiredTodosResult = result;
        if (result.data) {
            this.todos = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.todos = undefined;
        }
    }

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
        return this.todo.Category__c == 'Today'? "slds-badge slds-theme_success":
        (this.todo.Category__c == 
            'Tomorrow'?"slds-badge slds-theme_warning":
            "slds-badge"); 
    }

    // @api
    // get _category() { 
    //     return getFieldValue(this.todo.data, CATEGORY__C_FIELD);
    // }
  

}