@isTest 
public class LeadProcessorTest {

  @testSetup
    static void setup() {
	List<Lead> leads = new List<Lead>();
    for (Integer i=0;i<200;i++) {
            leads.add(new Lead(LastName = 'Johnny '+i, Company = 'Company '+i));
        }
        insert leads;
    }


	@IsTest	
    static void test() {
        Test.startTest();
        
        LeadProcessor lpcsr = new LeadProcessor();
        Id batchId = Database.executeBatch(lpcsr);
        
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(200, [select count() from Lead where LeadSource  = 'Dreamforce']);
    }

}