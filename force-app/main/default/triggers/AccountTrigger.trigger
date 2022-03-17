trigger AccountTrigger on Account (
    before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete) {
        
    if (Trigger.isBefore && Trigger.isInsert) {
			AccountTriggerHandler.handleBeforeInsert(Trigger.new);
		}	

	if (Trigger.isBefore && Trigger.isUpdate) {
			AccountTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}	
		
	if (Trigger.isBefore && Trigger.isDelete) {
			AccountTriggerHandler.handleBeforeDelete(Trigger.old, Trigger.oldMap);
		}

	if (Trigger.isAfter && Trigger.isInsert) {
			AccountTriggerHandler.handleAfterInsert(Trigger.new, Trigger.newMap);
		}	
	
	if (Trigger.isAfter && Trigger.isUpdate) {
			AccountTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}	

	if (Trigger.isAfter && Trigger.isDelete) {
			AccountTriggerHandler.handleAfterDelete(Trigger.old, Trigger.oldMap);
		}	
	
	if (Trigger.isAfter && Trigger.isUndelete) {
			AccountTriggerHandler.handleAfterUndelete(Trigger.new, Trigger.newMap);
		}	
		
	}