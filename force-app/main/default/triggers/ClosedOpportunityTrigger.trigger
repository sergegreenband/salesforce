trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
//Create an Apex trigger:
//Name: ClosedOpportunityTrigger
//Object: Opportunity
//Events: after insert and after update
//Condition: Stage is Closed Won
//Operation: Create a task:
//Subject: Follow Up Test Task
//WhatId: the opportunity ID (associates the task with the opportunity)
//Bulkify the Apex trigger so that it can insert or update 200 or more opportunities
List<Task> tasks = new List<Task>();
//List<Opportunity> opptys = new List<Opportunity>([SELECT Id FROM Opportunity WHERE Id IN :Trigger.New]);
    for(Opportunity op: Trigger.New){
        if(op.StageName == 'Closed Won'){
            tasks.add(new Task(Subject = 'Follow Up Test Task',
                               WhatId = op.Id));
        } 
    }
    if (tasks.size() > 0){insert tasks;}
    
}