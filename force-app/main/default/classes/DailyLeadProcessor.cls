public class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id, Name
            				FROM Lead
            				WHERE LeadSource = '' 
                            ORDER BY LeadSource 
                            LIMIT 200];
    
		for (Lead ld : leads) {
            ld.LeadSource = 'Dreamforce';
    }
		update leads;
    }
}