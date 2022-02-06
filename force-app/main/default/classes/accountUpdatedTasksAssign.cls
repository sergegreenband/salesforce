public class accountUpdatedTasksAssign {
  @InvocableMethod(label='Tasks Assign' description='If Account is updated and Account has more than 3 Tasks => assign all Tasks to one User (random active User)' category= 'Task')
      public static void assignTasks(List<id> ids) {

          // Create the task sObject list 
          List<Task> tasks = [SELECT OwnerId
								FROM Task
								WHERE WhatId IN :ids];
								ID ownID = tasks[0].OwnerId;
          // Assign all the retrieved tasks to OUR USER
          if (tasks.size()>3){        
          // Create the user sObject list 
          List<User> users = [SELECT Id, Name 
								FROM User
								WHERE IsActive = true];
                 
         // RANDOMIZE USER
          Integer userSize = users.size() - 1;
          Integer randomNumber = Integer.valueof((Math.random() * userSize));
		  User randomUser = users[randomNumber];
		  System.debug('random User now is: '+randomUser.Name);
          
          
          for(Task tsk: tasks){
				tsk.OwnerId = randomUser.Id;
          }
		// Update the tasks by using DML
		update tasks;
          }
      }
}