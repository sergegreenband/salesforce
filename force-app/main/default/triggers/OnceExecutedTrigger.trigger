trigger OnceExecutedTrigger on Account (before update) {
List<Account> accts = new List<Account>(
        [SELECT Id FROM Account WHERE Id IN :Trigger.New]);
if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            for(Account ac: Trigger.New){
            if (ac.Match_Billing_Address__c == true){
                ac.ShippingPostalCode = ac.BillingPostalCode;  
            } else {
              ac.ShippingPostalCode = '777';  
            }
          }   
        }   
    }
}