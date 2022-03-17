public class AccountHandler {
    public static Account insertNewAccount(String name){
       Account newAcc = new Account(Name=name);
        try {
   			 insert newAcc;
			} catch (DmlException e) {
    			System.debug('A DML exception has occurred: ' +
                e.getMessage());
                return null;
			}
//Account ResultAcc = [SELECT Name FROM Account WHERE Id =:newAcc.Id];
        return newAcc;
    }
}