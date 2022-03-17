public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String keyWord){
        List<List<SObject>> result = [FIND :keyWord IN NAME FIELDS 
                                     RETURNING Lead(FirstName,LastName), Contact(FirstName,LastName)];
       						Lead[] Leads = (Lead[])result[0];
							Contact[] Contacts = (Contact[])result[1];
			System.debug('Found the following leads.');
				for (Lead a : Leads) {
    			System.debug(a.LastName + ', ' + a.FirstName);
				}
			System.debug('Found the following contacts.');
			for (Contact c : Contacts) {
    		System.debug(c.LastName + ', ' + c.FirstName);
				}    
        	System.debug('Found the following RESULT');
    		System.debug(result);
        return result;
    }
}