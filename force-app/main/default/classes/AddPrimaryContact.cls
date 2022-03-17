public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;
    //Create an Apex class:
//Name: AddPrimaryContact
//Interface: Queueable
//Create a constructor for the class that accepts as its first argument a Contact sObject 
//and a second argument as a string for the State abbreviation
//
//The execute method must query for a maximum of 200 Accounts with the BillingState
// specified by the State abbreviation passed into the constructor and 
// insert the Contact sObject record associated to each Account. Look at the sObject clone() method.
// 
    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }
    public void execute(QueueableContext context) {
		List<Contact> primaryContacts = new List<Contact>();
        List<Account> accounts = [SELECT Id, Name, (SELECT FirstName, LastName, Id FROM Contacts) 
                                  FROM Account WHERE BillingState =:state LIMIT 200];
        for(Account acc: accounts){
            Contact c = contact.clone();
            c.AccountId = acc.Id;
            primaryContacts.add(c);
        }
        if (primaryContacts.size() > 0){
            insert primaryContacts;
        }
    }
}