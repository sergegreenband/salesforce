trigger AccountAddressTrigger on Account (before insert, before update) {
//Condition: Match Billing Address is true
//Operation: set the Shipping Postal Code to match the Billing Postal Code
List<Account> accts = new List<Account>(
        [SELECT Id FROM Account WHERE Id IN :Trigger.New]);
if (Trigger.isInsert||Trigger.isUpdate) {
        if (Trigger.isBefore) {
            // Process before insert OR update
            for(Account ac: Trigger.New){
            if (ac.Match_Billing_Address__c == true){
                ac.ShippingPostalCode = ac.BillingPostalCode;  
            }
          }   
        }   

    }
}