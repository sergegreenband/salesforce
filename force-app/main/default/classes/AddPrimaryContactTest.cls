@isTest
public class AddPrimaryContactTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(
                name='Test Account NY'+i, BillingState ='NY'
            ));
        }
        for (Integer j = 0; j < 50; j++) {
            accounts.add(new Account(
                name='Test Account CA'+j, BillingState ='CA'
            ));
        }
        insert accounts;
       
    }
    static testmethod void testQueueable() {
 		Contact contact = new Contact(FirstName = 'Michael', LastName = 'Jackson');
        insert contact;
        String state = 'CA';
        AddPrimaryContact newJob = new AddPrimaryContact(contact, state);
    
        Test.startTest();
        System.enqueueJob(newJob);
        Test.stopTest();
       
        System.assertEquals(50, [select count() from contact where accountId IN (select id from account where BillingState = 'CA')]);
    }
}