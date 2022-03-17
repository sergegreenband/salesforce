public class LeadProcessor implements
    Database.Batchable<sObject> {


    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID FROM Lead'
        );
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        List<Lead> leads = new List<Lead>();
        for (Lead ld : scope) {
            ld.LeadSource = 'Dreamforce';
            leads.add(ld);
        }
        update leads;
    }
    public void finish(Database.BatchableContext bc){
        System.debug(' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email

    }
}