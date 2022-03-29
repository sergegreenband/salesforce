import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import changeStatus from '@salesforce/apex/TodoController.changeStatus';
import { NavigationMixin } from 'lightning/navigation';
import SUB_TODO__C_OBJECT from '@salesforce/schema/Sub_Todo__c';
import SUB_TODO_NAME_FIELD from '@salesforce/schema/Sub_Todo__c.Name';
import SUB_STATUS__C_FIELD from '@salesforce/schema/Sub_Todo__c.Status__c';
import TODO_FIELD from '@salesforce/schema/Sub_Todo__c.Todo__c';
import ID_FIELD from '@salesforce/schema/Sub_Todo__c.Id';
export default class SubTodo extends LightningElement {
   subrecordId;
   status;
   header = 'Edit subtask';
   @api subtodo;
   @api objectApiName3 = SUB_TODO__C_OBJECT;
   @api subname = SUB_TODO_NAME_FIELD;

   connectedCallback() {
      this.subrecordId = this.subtodo.Id; 
  }

   handleDeleteSubTodo() {
      const deleteEvent = new CustomEvent('deleted', {
          detail: this.subtodo.Id
      });
      this.dispatchEvent(deleteEvent);     
  }
 
   handleStatusChange(event) {
      if (event.target.name === "status") {
         this.status = event.target.checked;
       //  console.log(this.status);
       } 

     const fields = {};
     fields[ID_FIELD.fieldApiName] = this.subrecordId;
     fields[SUB_STATUS__C_FIELD.fieldApiName] = this.status;
     const recordInput = {
       fields: fields
     };

      updateRecord(recordInput)

      .then((record) => {
       //  console.log(record);
         const toast = new ShowToastEvent({
            title: "Success!",
            message: "task status changed" ,
            variant: "success"
         });
         this.dispatchEvent(toast); 
         const updateSubStatusEvent = new CustomEvent('subupdated', {
            detail: this.subtodo.Id
        });
        this.dispatchEvent(updateSubStatusEvent);
   })
   .catch(error => {
         this.error = error.message;
   });
   }

   handleShowModalSub() {
      const modal = this.template.querySelector('c-modal');
      modal.show();
  }

  handleCancelModalSub() {
      const modal = this.template.querySelector('c-modal');
      modal.hide();
  }

  handleSuccessSub(event) {
   const toastEvent = new ShowToastEvent({
       title: "Success!",
       message: "Sub-to-do updated!",// + event.detail.id,
       variant: "success"
   });
   this.dispatchEvent(toastEvent);  
  
   const updateSubEvent = new CustomEvent('subupdated', {
       detail: this.subtodo.Id
   });
   this.dispatchEvent(updateSubEvent);
}
   
}