import { LightningElement, track, wire, api } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import { updateRecord } from "lightning/uiRecordApi";
import getAllSubTodos from '@salesforce/apex/TodoController.getAllSubTodos';
import saveSubTodo from '@salesforce/apex/TodoController.saveSubTodo';
import { reduceErrors } from 'c/ldsUtils';
import { NavigationMixin } from 'lightning/navigation';
import TODO_TILE_UPDATE_MESSAGE from '@salesforce/messageChannel/TodoTileUpdate__c';

import todoResources from '@salesforce/resourceUrl/todo_app';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import TODO__C_OBJECT from '@salesforce/schema/Todo__c';
import TODO_ID_FIELD from '@salesforce/schema/Todo__c.Id';
import NAME_FIELD from '@salesforce/schema/Todo__c.Name';
import SUB_TODO__C_OBJECT from '@salesforce/schema/Sub_Todo__c';
import SUB_TODO_NAME_FIELD from '@salesforce/schema/Sub_Todo__c.Name';
import SUB_STATUS__C_FIELD from '@salesforce/schema/Sub_Todo__c.Status__c';
import TODO_FIELD from '@salesforce/schema/Sub_Todo__c.Todo__c';
import DESCRIPTION__C_FIELD from '@salesforce/schema/Todo__c.Description__c';
import CATEGORY__C_FIELD from '@salesforce/schema/Todo__c.Category__c';
import STATUS__C_FIELD from '@salesforce/schema/Todo__c.Status__c';
import PRIORITY__C_FIELD from '@salesforce/schema/Todo__c.Priority__c';
//const fields = [TODO_ID_FIELD, NAME_FIELD];
export default class TodoTile extends LightningElement {
 
    header = 'Edit record';
    @track wiredSubTodosResult;
    @api name = NAME_FIELD;
    @api description = DESCRIPTION__C_FIELD;
    @api category = CATEGORY__C_FIELD;
    @api priority = PRIORITY__C_FIELD;
    @api status =  STATUS__C_FIELD;
    @api objectApiName = TODO__C_OBJECT;
    @api objectApiName2 = SUB_TODO__C_OBJECT;
    @track error;
    @track subtodos;
    @api todo;
    recordId;
    @api done = 'draft';
    @api id = TODO_ID_FIELD;
    fields2 = [SUB_TODO_NAME_FIELD, SUB_STATUS__C_FIELD, TODO_FIELD];
    @api subname='';// = SUB_TODO_NAME_FIELD;
    @api todofield='';// = TODO_FIELD;

    connectedCallback() {
        this.recordId = this.todo.Id; 
    }
      
   @wire(getAllSubTodos, {recordId: '$recordId'})
        loadSubTodos(result) {
//--------------------------Status vars--------------------------------------//  
            const fieldsDone = {};
            fieldsDone[TODO_ID_FIELD.fieldApiName] = this.recordId;
            fieldsDone[STATUS__C_FIELD.fieldApiName] = 'done';
               const inputSubDone = {
                 fields: fieldsDone
               };
               let input = inputSubDone;

               const fieldsProgress = {};
               fieldsProgress[TODO_ID_FIELD.fieldApiName] = this.recordId;
               fieldsProgress[STATUS__C_FIELD.fieldApiName] = 'in progress';
               const inputSubProgress = {
                 fields: fieldsProgress
               };
               const fieldsDraft = {};
               fieldsDraft[TODO_ID_FIELD.fieldApiName] = this.recordId;
               fieldsDraft[STATUS__C_FIELD.fieldApiName] = 'draft';
               const inputSubDraft = {
                 fields: fieldsDraft
               };
            this.wiredSubTodosResult = result;
            let count =0;
            if (result.data) {
                this.subtodos = result.data;
                this.error = undefined;
                for(let i=0; i<this.subtodos.length; i++){
                    console.log(this.subtodos[i].Status__c);
                    if(this.subtodos[i].Status__c === true){
                        count += 1;
                        console.log(count);
                    } 
                }
                if(count == this.subtodos.length){
                    this.done = 'done';
                    input = inputSubDone;
               
                } else if (count < this.subtodos.length && count > 0){
                    this.done = 'in progress'
                    input = inputSubProgress;
                } else if(count == 0){
                    this.done = 'draft'
                    input = inputSubDraft;
                }
                    updateRecord(input)
                    .then((record) => {
                                   console.log(record);
                                   refreshApex(this.wiredSubTodosResult);
                                   const updateEvent = new CustomEvent('updated', {
                                      detail: this.todo.Id
                                  });
                                  console.log('WIREDTODO '+ this.todo.Name + 'status: ' + this.todo.Status__c);
                                  this.dispatchEvent(updateEvent);
                             })
                             .catch(error => {
                                   this.error = error.message;
                             });

            } else if (result.error) {
                this.error = result.error;
                this.subtodos = undefined;
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

    handleSubDelete(event) {
        const deletedId = event.detail;
        deleteRecord(deletedId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'SubToDo Deleted Successfully',
                        message: 'Sub-Todo deleted',
                        variant: 'success'
                    })
                );
                return refreshApex(this.wiredSubTodosResult);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
            });
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

    handleShowSubModal() {
        const submodal = this.template.querySelector('c-submodal');
        submodal.show();
    }

    handleCancelSubModal() {
        const submodal = this.template.querySelector('c-submodal');
        submodal.hide();
    }
    
    @track accRecord = {
        Name : SUB_TODO_NAME_FIELD,
        Status__c : SUB_STATUS__C_FIELD,//'false'
        Todo__c : TODO_FIELD //'a098c00000sj82WAAQ',
    };

    handleNameChange(event) {
        this.accRecord.Name = event.target.value;
        this.accRecord.Status__c = 'false';
        this.accRecord.Todo__c = this.recordId;//'a098c00000sj82WAAQ';
        window.console.log('Name ==> '+this.accRecord.Name);
    }

    handleSave() {
        saveSubTodo({newsubtodo: this.accRecord})
        .then(() => {
            const toastSUB = new ShowToastEvent({
                title: "Success!",
                message: "a task has just been created" ,
                variant: "success"
            });
            this.dispatchEvent(toastSUB); 
            this.accRecord = {};
            refreshApex(this.wiredSubTodosResult);
        })
        .catch(error => {
            this.error = error.message;
        });
    }

        handleSubUpdate() {
        //        const subfields = {};
        //        subfields[TODO_ID_FIELD.fieldApiName] = this.recordId;
        //        subfields[STATUS__C_FIELD.fieldApiName] = 'done';
        //        const recordInputSub = {
        //          fields: subfields
        //        };
        //   if(this.done){
        //         updateRecord(recordInputSub)
        //         .then((record) => {
        //            console.log(record);
        //            const toast = new ShowToastEvent({
        //               title: "Success!",
        //               message: "Todo" + this.todo.Name + "completed" ,
        //               variant: "success"
        //            });
        //            this.dispatchEvent(toast); 
        //      })
        //      .catch(error => {
        //            this.error = error.message;
        //      });
        //      console.log('TODO CHANGED: '+this.todo.Name);
            return refreshApex(this.wiredSubTodosResult);
    }
//}

    /*-------STYLING-------------------------------------------------------*/
    @api
    get categoryStyle() { 
        return this.todo.Category__c == 'Today'? "slds-badge slds-theme_error":
        (this.todo.Category__c == 
            'Tomorrow'?"slds-badge slds-theme_warning":
            "slds-badge slds-theme_success"); 
    }

    
  

}