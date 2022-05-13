public class SFDC_Conidesk_Integration {
	
    public static void getBitcoinPrice() {
        //Authentication - NA
        //Method - GET
        //End Point - https://api.coindesk.com/v1/bpi/currentprice.json
        //Rquest Body - NA
        //Response Body - Yes
		
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.coindesk.com/v1/bpi/currentprice.json');
        request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('SFDC_Conidesk_Integration::getBitcoinPrice::StatusCode ' + response.getStatusCode());
        System.debug('SFDC_Conidesk_Integration::getBitcoinPrice::Body' + response.getBody());
    }
}