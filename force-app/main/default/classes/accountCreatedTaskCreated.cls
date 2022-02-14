public class accountCreatedTaskCreated {
  @InvocableMethod(label='Insert Task' description='When an Account is created, inserts a task with Subject “Negotiations with {Account.Name}”, links created Account with this Task' category= 'Task')
      public static void insertTask(List<id> ids) {
         //SOQL to get account record 
          List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :ids];
         // Create the task sObject list 
          List<Task> tasks = new List<Task>();
          for(Account ac: accounts){
              // Create a new task sObject 
          tasks.add(new Task (Subject = 'Negotiations with '+ac.Name, WhatId = ac.Id));   
          }
		// Insert the task by using DML
		insert tasks;
  }
}