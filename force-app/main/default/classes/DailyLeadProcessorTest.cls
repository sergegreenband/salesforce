@isTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
        // Create records
        List<Lead> leads = new List<Lead>();
   		for (Integer i=0;i<200;i++) {
            leads.add(new Lead(LastName = 'Johnny '+i, Company = 'Company '+i));
        }
        insert leads;
        // Get the IDs of the opportunities we just inserted
        Map<Id, Lead> leadMap = new Map<Id, Lead>(leads);
        List<Id> leadIds = new List<Id>(leadMap.keySet());
       
        Test.startTest();

        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new DailyLeadProcessor());
        // Verify the scheduled job has not run yet.
        List<Lead> leadsNew = [SELECT Id
            FROM Lead
            WHERE Id IN :leadIds AND LeadSource = 'Dreamforce'];
        System.assertEquals(0, leadsNew.size(), 'leads updated before the job had run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        // Now that the scheduled job has executed,
        // check that our tasks were created
         leadsNew = [SELECT Id
            FROM Lead
            WHERE Id IN :leadIds AND LeadSource = 'Dreamforce'];
        System.assertEquals(leadIds.size(),
            leadsNew.size(),
            'Leads were not updated');
    }
}