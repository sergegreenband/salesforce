public class AccountDeleteRest {
    public static HttpResponse DeleteAccountById(String id) {
        try{
            HttpRequest tokenRequest = new HttpRequest();
            tokenRequest.setMethod('POST');
            tokenRequest.setEndpoint('https://login.salesforce.com/services/oauth2/token');
 
            Credentials_api_2__c cred = Credentials_api_2__c.getInstance(UserInfo.getUserId());
			String CLIENT_ID = cred.login__c;
            String CLIENT_SECRET = cred.client_secret__c;
            String USERNAME = cred.username__c;
            String PASSWORD = cred.password__c;
       /*
            system.debug('CLIENT_ID = '+CLIENT_ID+'\n'+
                         'CLIENT_SECRET = '+CLIENT_SECRET+'\n'+
                         'USERNAME = '+USERNAME+'\n'+
                         'PASSWORD = '+PASSWORD);
       */     
            tokenRequest.setBody('grant_type=password' + '&client_id='+CLIENT_ID + 
                                 '&client_secret='+CLIENT_SECRET + '&username='+USERNAME + '&password='+PASSWORD);
            
            Http http1 = new Http();
            HttpResponse responseToken = http1.send(tokenRequest);
            Map<String, Object> authMap = (Map<String, Object>) JSON.deserializeUntyped(responseToken.getBody());
            system.debug(' response Status :'+ responseToken.getStatus()+' response StatusCode :'+responseToken.getStatusCode());
            system.debug(' responseToken :'+ responseToken.getBody());
            
            
            String endpoint = authMap.get('instance_url') + '/services/apexrest/Accounts/'+String.valueOf(id);
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + authMap.get('access_token')); 
            request.setHeader('accept','application/json');
            request.setEndpoint(endpoint);
            request.setMethod('DELETE');
            Http http = new Http();
            HTTPresponse res= http.send(request);
            system.debug(' response Status :'+ res.getStatus()+' response StatusCode :'+res.getStatusCode());
            system.debug(' Response : '+ res);

            return res;
        } catch(exception e){
            System.debug('ERROR: '+ e.getMessage());
            return null;
        }
    }
    
    
}