@isTest
public class SFDC_Conidesk_IntegrationMock implements HttpCalloutMock{
	
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        
        String body = '{\"time\":{\"updated\":\"May 11, 2022 03:01:00 UTC\",\"updatedISO\":\"2022-05-11T03:01:00+00:00\",\"updateduk\":\"May 11, 2022 at 04:01 BST\"},\"disclaimer\":\"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org\",\"chartName\":\"Bitcoin\",\"bpi\":{\"USD\":{\"code\":\"USD\",\"symbol\":\"&#36;\",\"rate\":\"31,464.2835\",\"description\":\"United States Dollar\",\"rate_float\":31464.2835},\"GBP\":{\"code\":\"GBP\",\"symbol\":\"&pound;\",\"rate\":\"25,485.7235\",\"description\":\"British Pound Sterling\",\"rate_float\":25485.7235},\"EUR\":{\"code\":\"EUR\",\"symbol\":\"&euro;\",\"rate\":\"29,794.5998\",\"description\":\"Euro\",\"rate_float\":29794.5998}}}';
        response.setBody(body);
        return response;
    }
}