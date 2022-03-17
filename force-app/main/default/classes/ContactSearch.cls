public class ContactSearch {
    public static List<Contact> searchForContacts(String lastName,String postalCode){
        List<Contact> cts = [SELECT Id, Name FROM Contact 
                 WHERE LastName = :lastName AND MailingPostalCode=:postalCode];
        System.debug(cts);
        	return cts;
    }
}