public class BatchScheduler implements Schedulable{
    public void execute(SchedulableContext ctx) {
        
        BatchClass batchIterable = new BatchClass();
		Id batchId1 = Database.executeBatch(batchIterable);
        
        BatchQueryLocatorClass batchQueryLocator = new BatchQueryLocatorClass();
		Id batchId2 = Database.executeBatch(batchQueryLocator);
        
   //     BatchQueryLocator_Console batchQueryLocatorConsole = new BatchQueryLocator_Console();
	//	  Id batchId3 = Database.executeBatch(batchQueryLocatorConsole);
        
    }
}

//	String CRON_EXP = '0 0/30 * 1/1 * ? *';
//    String jobId = System.schedule('BatchScheduler',
 //           CRON_EXP,
 //           new BatchScheduler());