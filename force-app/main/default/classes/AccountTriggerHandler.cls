public class AccountTriggerHandler {
    
    public static void handleBeforeInsert(List<Account> newList){
		
	}

    public static void handleBeforeUpdate(List<Account> newList, Map<Id, Account> newMap, List<Account> oldList, Map<Id, Account> oldMap){
	 
	}

	public static void handleBeforeDelete(List<Account> oldList, Map<Id, Account> oldMap){
	
	} 

	public static void handleAfterInsert(List<Account> newList, Map<Id, Account> newMap){
	List<Id> Ids = new List<Id>(); 
        System.debug('list created');

        for (Account a: newList){
        		Ids.add(a.Id);
                System.debug('ID added '+a.Id);
        }
        if (Ids.size() > 0) {
            taskCreateFutureMethod(Ids);
            System.debug('Future method called');
        } 
	} 

	public static void handleAfterUpdate(List<Account> newList, Map<Id, Account> newMap, List<Account> oldList, Map<Id, Account> oldMap){
      List<Id> Ids = new List<Id>(); 
        System.debug('list created');

        for (Account a: newList){
            if (a.BillingStreet != oldMap.get(a.Id).BillingStreet ||
                a.BillingCity != oldMap.get(a.Id).BillingCity|| 
                a.BillingState != oldMap.get(a.Id).BillingState|| 
                a.BillingPostalCode != oldMap.get(a.Id).BillingPostalCode||  
                a.BillingCountry != oldMap.get(a.Id).BillingCountry|| 
                a.BillingLatitude != oldMap.get(a.Id).BillingLatitude|| 
                a.BillingLongitude != oldMap.get(a.Id).BillingLongitude|| 
                a.BillingGeocodeAccuracy  != oldMap.get(a.Id).BillingGeocodeAccuracy)
    		{
        		Ids.add(a.Id);
                System.debug('ID added '+a.Id);
    		}
        }
        if (Ids.size() > 0) {
          //FUTURE METHOD CALL  
          //  accountFutureMethod(Ids);
          //  System.debug('Future method called');
          
          //QUEUEABLE METHOD CALL  
		  System.enqueueJob(new QueueableContactUpdate(Ids));
          System.debug('Queueable method called'); 
        } 
	} 

	public static void handleAfterDelete(List<Account> oldList, Map<Id, Account> oldMap){
	String CRON_EXP = '0 20 * * * ? ';
    String jobId = System.schedule('BatchScheduler',
            CRON_EXP,
            new BatchScheduler());
	} 

	public static void handleAfterUndelete(List<Account> newList, Map<Id, Account> newMap){
	
	} 
   
    // I FUTURE METHOD accountFutureMethod FOR CONTACTS UPDATE
    @future
    public static void accountFutureMethod(List<Id> accountIds){
        
        //a. For accounts in which BillingAddress changed select all related Contacts
		//b. Set to all Contacts Is Synced = false; Processed By Future = true;	
	
        List<Contact> contactsToUpdate = new List<Contact>();  
        List<Account> accounts = [Select Id, Name, (Select Id FROM Contacts) from Account Where Id IN :accountIds];
        
        for(Account acc: accounts){
            List<Contact> contactList = acc.Contacts;
            contactsToUpdate.addAll(contactList);
            System.debug('List of contacts: '+contactList);
        }
            for(Contact c: contactsToUpdate){
                c.Is_Synced__c = False;
                c.Processed_By_Furure__c = True;
                System.debug('Contact '+c.FirstName+' '+c.LastName+' updated');
            }
        update contactsToUpdate;
    }
    
    // II FUTURE METHOD taskCreateFutureMethod FOR TASK CREATE
    @future
    public static void taskCreateFutureMethod(List<Id> accountIds){
        
        //move task creation logic to future method; set Task.IsSynced = false	
	    List<Account> accounts = [Select Id, Name from Account Where Id IN :accountIds];
        List<Task> tasks = new List<Task>();
          for(Account ac: accounts){
              // Create a new task sObject 
          tasks.add(new Task (Subject = 'Task successfully created IN THE FUTURE... '+ac.Name, WhatId = ac.Id, Is_Synced__c = False));   
          }
		// Insert the task by using DML
		insert tasks;
    }
}