public class BatchQueryLocator_Console implements
    Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
          'Select Id, Name, BillingStreet, BillingCity, BillingState,' +
                                'BillingPostalCode, BillingCountry, BillingLatitude,' +
                                'BillingLongitude, BillingGeocodeAccuracy, ' +
                                '(Select Id, FirstName, LastName, Is_Synced__c  FROM Contacts) from Account');
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
       List<Contact> contactsToUpdate = new List<Contact>();  
       List<Account> accsToUpdate = new List<Account>();       
        for(Account acc: scope){
            List<Contact> contacts = acc.Contacts;
            List<Contact> contactsUpdated = new List<Contact>();
            for(Contact con: contacts){          
                if(con.Is_Synced__c == false)
                {
                  con.Is_Synced__c = true;
                  con.MailingStreet = acc.BillingStreet;
                  con.MailingCity = acc.BillingCity;
                  con.MailingState = acc.BillingState; 
                  con.MailingPostalCode = acc.BillingPostalCode; 
                  con.MailingCountry = acc.BillingCountry;
                  con.MailingLatitude = acc.BillingLatitude; 
                  con.MailingLongitude = acc.BillingLongitude; 
                  con.MailingGeocodeAccuracy = acc.BillingGeocodeAccuracy;
                  contactsUpdated.add(con);
                  contactsToUpdate.add(con);      
                  System.debug('Contact '+con.FirstName+' '+con.LastName+' updated');
                	}           
                } 
            	if(contactsUpdated.size() > 0)
            	acc.Updated_By_Contact__c = true;
            	accsToUpdate.add(acc);
            System.debug('Accounts updated: '+ acc.Name);
            }
       
       		update contactsToUpdate;
      		update accsToUpdate;
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