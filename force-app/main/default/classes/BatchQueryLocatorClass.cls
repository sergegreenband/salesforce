public class BatchQueryLocatorClass implements
    Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
          'SELECT Id, OwnerId, Account.OwnerId, Account.Updated_By_Task__c, Task.Is_Synced__c, Task.WhatId FROM Task WHERE WhatId IN (SELECT Id FROM Account) AND Task.Is_Synced__c = false');
    }
    public void execute(Database.BatchableContext bc, List<Task> scope){
        
        //UPDATING TASKS
        Set<Account> accs = new Set<Account>();
   		List<Task> tasks = new List<Task>();
        for (Task t: scope) {
            t.Is_Synced__c = true;   
            t.Account_Owner__c = [SELECT Name FROM User WHERE Id = :t.Account.OwnerId].Name;
            tasks.add(t);
			accs.add([SELECT Id FROM Account WHERE Id = :t.WhatId]);
        }
        update tasks;
        
        //UPDATING ACCOUNTS
        List<Account> accsList = new List<Account>(accs);
        for (Account a: accsList) {
            a.Updated_By_Task__c = true;
        }
        update accsList;
        System.debug('Added IDs: '+accsList);
    }
    public void finish(Database.BatchableContext bc){
        System.debug(' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }
}