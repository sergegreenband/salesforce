public class noTrigger_Queueable implements Queueable {
	List<Id> accountIds;

    public noTrigger_Queueable(List<Id> accountIds) {
        this.accountIds = accountIds;
    }
    public void execute(QueueableContext context) {
		List<Account> accounts = [Select Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude, BillingGeocodeAccuracy, (Select Id, FirstName, LastName, Is_Synced__c, Processed_By_Furure__c FROM Contacts) from Account Where Id IN :accountIds LIMIT 150]; 
       List<Contact> contactsToUpdate = new List<Contact>();
        for(Account acc: accounts){
            List<Contact> contacts = acc.Contacts;
            if(acc.BillingCity != null ||
                acc.BillingCountry!= null ||
              	 acc.BillingPostalCode != null ||
              	  acc.BillingState!= null ||
               acc.BillingStreet!= null){
                   
              for(Contact con: contacts){          

                  con.Is_Synced__c = false;
                  con.Processed_By_Queue__c = true;
    
                  contactsToUpdate.add(con);      
                  System.debug('Contact '+con.FirstName+' '+con.LastName+' updated');
                	}   
               }
          } 
        
        if(contactsToUpdate.size() > 0){
        update contactsToUpdate;
        }
	}
}