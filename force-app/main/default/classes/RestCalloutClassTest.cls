@IsTest
private class RestCalloutClassTest {
    static final String TEST_REQUEST ='{"Name":"TEST_CREATE", "Rating":"Hot"}';
    static final String TEST_ID ='0017Q000008AobpQAC';
    
    @isTest static  void testGetCallout() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call method to test
        Test.startTest();
        HttpResponse result = AccountRestCalloutClass.GetAccountById(TEST_ID);
        Test.stopTest();
        
        // Verify
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');  
        System.assertEquals('application/json;charset=UTF-8',
                            result.getHeader('Content-Type'),
                            'The content type value is not expected.');   
        Map<String, Object> results = (Map<String, Object>) 
            JSON.deserializeUntyped(result.getBody());
        List<Object> accounts = (List<Object>) results.values();
        System.assertEquals(2, accounts.size(), 'The array should only contain 2 items.');          
    }  
    
    @isTest 
    static void testPostCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        // 
        Test.startTest();
        HttpResponse response = AccountRestCalloutClass.createAccount('TEST_CREATE', 'Hot');
        Test.stopTest();
        
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = AccountHttpCalloutMock.BODY;
        
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
    
    @isTest static  void testDeleteCallout() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAccountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call method to test
        Test.startTest();
        HttpResponse result = AccountRestCalloutClass.DeleteAccountById(TEST_ID);
        Test.stopTest();
        
        // Verify
        System.assertNotEquals(null,result, 'The callout returned a null response.');
        System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');  
        System.assertEquals('application/json;charset=UTF-8',
                            result.getHeader('Content-Type'),
                            'The content type value is not expected.');         
    }  
    
    @isTest static void testPatchCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock2()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        // 
        Test.startTest();
        HttpResponse response = AccountRestCalloutClass.patchAccount('Cold', TEST_ID);
        Test.stopTest();
        
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = AccountHttpCalloutMock2.BODY;
        
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
    
   @isTest static void testPutCallout1() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock3()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 

        Test.startTest();
        HttpResponse response = AccountRestCalloutClass.putAccount('WOOOHOOO','Cold', null);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = AccountHttpCalloutMock3.BODY;
        
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
        Test.stopTest();
    }
    
    @isTest static void testPutCallout2() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock4()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 

        Test.startTest();
        HttpResponse response = AccountRestCalloutClass.putAccount('SSSSSSS','Warm', TEST_ID);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = AccountHttpCalloutMock4.BODY;
        
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
        Test.stopTest();
    }
    
}