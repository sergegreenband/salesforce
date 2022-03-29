import { publish, MessageContext } from 'lightning/messageService';
import TODO_LIST_UPDATE_MESSAGE from '@salesforce/messageChannel/TodoListUpdate__c';
import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import TODO__C_OBJECT from '@salesforce/schema/Todo__c';
import NAME_FIELD from '@salesforce/schema/Todo__c.Name';
import DESCRIPTION__C_FIELD from '@salesforce/schema/Todo__c.Description__c';
import CATEGORY__C_FIELD from '@salesforce/schema/Todo__c.Category__c';
import STATUS__C_FIELD from '@salesforce/schema/Todo__c.Status__c';
import PRIORITY__C_FIELD from '@salesforce/schema/Todo__c.Priority__c';

import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { reduceErrors } from 'c/ldsUtils';
import getAllTodos from '@salesforce/apex/TodoController.getAllTodos';
import searchTodos from '@salesforce/apex/TodoController.searchTodos';
import filterTodos from '@salesforce/apex/TodoController.filterTodos';

export default class TodoList extends NavigationMixin(LightningElement) {
  header = 'Create record';
  searchTerm = '';
  searchTermDesc = '';
  @track todos;
  @track subtodos;
  @track loadedsubtodos;
  @track error;
  @track wiredTodosResult;
  objectApiName = TODO__C_OBJECT;
  fields = [NAME_FIELD, DESCRIPTION__C_FIELD, CATEGORY__C_FIELD, PRIORITY__C_FIELD, STATUS__C_FIELD];
  
  @wire(getAllTodos)
  wiredTodos(result) {
      this.wiredTodosResult = result;
      if (result.data) {
          this.todos = result;
          this.error = undefined;
      } else if (result.error) {
          this.error = result.error;
          this.todos = undefined;
      }
  }

  handleSuccess(event) {
    const toastEvent = new ShowToastEvent({
        title: "to-do record created",
        message: "Record ID: " + event.detail.id,
        variant: "success"
    });
    this.dispatchEvent(toastEvent);  
}

  @wire(MessageContext) messageContext;
  @wire(searchTodos, {searchTerm: '$searchTerm', searchTermDesc: '$searchTermDesc'})
  loadTodos(result) {
  this.todos = result;
  if (result.data) {
    const message = {
      todos: result.data
    };
    publish(this.messageContext, TODO_LIST_UPDATE_MESSAGE, message);
  }
}

handleSearchTermChange(event) {
  window.clearTimeout(this.delayTimeout);
  const searchTerm = event.target.value;
  // eslint-disable-next-line @lwc/lwc/no-async-operation
  this.delayTimeout = setTimeout(() => {
    this.searchTerm = searchTerm;
  }, 300);
}

get hasResults() {
  return (this.todos.data.length > 0);
}

handleTodoView(event) {
  const todoId = event.detail;
  this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
      recordId: todoId,
      objectApiName: 'Todo__c',
      actionName: 'view',
    },
  });
}

  handleUpdate() {
      return refreshApex(this.wiredTodosResult);
}

  handleDelete(event) {
    const recordId = event.detail;
    deleteRecord(recordId)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Deleted Successfully',
                    message: 'Todo deleted',
                    variant: 'success'
                })
            );
            return refreshApex(this.wiredTodosResult);
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
  
        handleShowModal() {
          const modal = this.template.querySelector('c-modal');
          modal.show();
        }

        handleCancelModal() {
          const modal = this.template.querySelector('c-modal');
          modal.hide();
            return refreshApex(this.wiredTodosResult);
        }

/*----------------------------FILTERING-----------------------*/
    varCat = '';
    varCatOptions = [
        { label: 'Today', value: 'Today' },
        { label: 'Tomorrow', value: 'Tomorrow' },
        { label: 'Later', value: 'Later' }, 
        { label: 'All', value: '' }    
    ];

    varPrior = '';
    varPriorOptions = [
        { label: 'low', value: 'low' },
        { label: 'medium', value: 'medium' },
        { label: 'high', value: 'high' }, 
        { label: 'All', value: '' }      
    ];

    varStat = '';
    varStatOptions = [
        { label: 'draft', value: 'draft' },
        { label: 'in progress', value: 'in progress' },
        { label: 'done', value: 'done' },
        { label: 'All', value: '' }      
    ];
    varCatChange(event) {
      const varCat = event.target.value;
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.varCat = varCat;
    }
    varPriorChange(event) {
      const varPrior = event.target.value;
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.varPrior = varPrior;
    }
    varStatChange(event) {
      const varStat = event.target.value;
      // eslint-disable-next-line @lwc/lwc/no-async-operation
      this.varStat = varStat;
    }
    handleClearFilter(event) {
      this.varCat = '';
      this.varPrior = '';
      this.varStat = '';
    }

  @wire(filterTodos, {varCat: '$varCat', varPrior: '$varPrior', varStat: '$varStat'})
    filterTodosCat(result) {
    this.todos = result;
    if (result.data) {
        const message4 = {
        todos: result.data
      };
      publish(this.messageContext, TODO_LIST_UPDATE_MESSAGE, message4);
    }
  }

}