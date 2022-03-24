@isTest
global class AccountHttpCalloutMock3 implements HttpCalloutMock {
    public static final String BODY = '{"Name":"WOOOHOOO", "Rating":"Cold"}';
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