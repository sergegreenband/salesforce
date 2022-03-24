@isTest
global class AccountHttpCalloutMock implements HttpCalloutMock {
    public static final String BODY = '{"Name":"TEST_CREATE", "Rating":"Hot"}';
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(BODY);
        response.setStatusCode(200);
        return response; 
    }
}