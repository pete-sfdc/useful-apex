public class HttpCalloutMockService implements HttpCalloutMock {

	public class HttpCalloutMockServiceException extends Exception {}

	// optional, defaults to success
	public Integer code {get;set;} {code = 200;}

	// optional, defaults to 'Your request was successful'
	public String status {get;set;} {status = 'Your request was successful';}

	public String body {get;set;}
	public Map<String, String> responseHeaders {get;set;}



	// MANDITORY METHOD FROM THE INTERFACE
	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		for (String key:responseHeaders.keySet()) {
			res.setHeader(key,responseHeaders.get(key));
		}
		res.setBody(this.body);
		res.setStatusCode(this.code);
		res.setStatus(this.status);
		return res;
	}



	// Constructors START
	public HttpCalloutMockService(String body, Map<String, String> responseHeaders) {
		this.body = body;
		this.responseHeaders = responseHeaders;
	}

	public HttpCalloutMockService(String status, String body, Map<String, String> responseHeaders) {
		this.status = status;
		this.body = body;
		this.responseHeaders = responseHeaders;
	}

	public HttpCalloutMockService(Integer code, String body, Map<String, String> responseHeaders) {
		this.code = code;
		this.body = body;
		this.responseHeaders = responseHeaders;
	}

	public HttpCalloutMockService(Integer code, String status, String body, Map<String, String> responseHeaders) {
		this.code = code;
		this.status = status;
		this.body = body;
		this.responseHeaders = responseHeaders;
	}
	// Constructors END



	// Static Set Methods START
	public static void set(String body, Map<String, String> responseHeaders) {
		Test.setMock(HttpCalloutMock.class, new HttpCalloutMockService(body, responseHeaders));
	}

	public static void set(Integer code, String body, Map<String, String> responseHeaders) {
		Test.setMock(HttpCalloutMock.class, new HttpCalloutMockService(code, body, responseHeaders));
	}

	public static void set(String status, String body, Map<String, String> responseHeaders) {
		Test.setMock(HttpCalloutMock.class, new HttpCalloutMockService(status, body, responseHeaders));
	}

	public static void set(HttpCalloutMockService theMock) {
		Test.setMock(HttpCalloutMock.class, theMock);
	}

	public static void set(Integer code, String status, String body, Map<String, String> responseHeaders) {
		Test.setMock(HttpCalloutMock.class, new HttpCalloutMockService(code, status, body, responseHeaders));
	}
	// Static Set Methods END
}