@isTest 
public class AccountProcessorTest {

  @IsTest
  private static void testCountContacts() {
	Account newAccount = new Account(Name = 'Test Account Future');
    insert newAccount;
    Contact newContact1 = new Contact(FirstName = 'John',
                                    LastName = 'Doe',
                                    AccountId = newAccount.Id);
    Contact newContact2 = new Contact(FirstName = 'Jane',
                                    LastName = 'Dir',
                                    AccountId = newAccount.Id);
      
      List<Id> accIds = new List<Id>();
		accIds.add(newAccount.Id);
		
      
    Test.startTest();
				AccountProcessor.countContacts(accIds);
    Test.stopTest();
    // runs callout and check results


  }
}