public class QueueableContactUpdate implements Queueable {
	List<Id> accountIds;

    public QueueableContactUpdate(List<Id> accountIds) {
        this.accountIds = accountIds;
    }
    public void execute(QueueableContext context) {
		List<Contact> contactsToUpdate = new List<Contact>();  
        List<Account> accounts = [Select Id, Name, (Select Id, FirstName, LastName  FROM Contacts) from Account Where Id IN :accountIds];
        
        for(Account acc: accounts){
            List<Contact> contactList = acc.Contacts;
            contactsToUpdate.addAll(contactList);
            System.debug('List of contacts: '+contactList);
        }
            for(Contact c: contactsToUpdate){
                c.Is_Synced__c = False;
                c.Processed_By_Queue__c = True;
                System.debug('Contact '+c.FirstName+' '+c.LastName+' updated');
            }
        update contactsToUpdate;
    }
}