public class SFDC_WS_Integrations {
	
    public static void getCurrentWeatherInfo(String cityName) { //null or ''
        if (cityName != null && String.isNotBlank(cityName)) { //'New York'
            //http://api.weatherstack.com/current?access_key=253896baf7b30004d2ae899d98f69271&query=New%20York
            //String endPoint2 = 'http://api.weatherstack.com/current?access_key=253896baf7b30004d2ae899d98f69271&query='+cityName;

            String endPoint = 'http://api.weatherstack.com/current?access_key='+System.Label.WhetherStackAPIkey+'&query='+cityName;
            
            //Create Http Request
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(endPoint);
            
            Http http = new Http();
            
            //Send Request
            HttpResponse response = http.send(request);
            System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::StatusCode ' + response.getStatusCode());
            System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::Body' + response.getBody());
            
            //Check if the Status Code is 200
            if (response.getStatusCode() == 200) {
                WhetherStackResponse__c wsApi = new WhetherStackResponse__c();
                wsApi.WhetherInformation__c  = response.getBody();
                wsApi.City__c = cityName;
                
                try {
                    insert wsApi;
                } catch(Exception exp) {
                    
                }
            }else {
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::StatusCode ' + response.getStatusCode());
                
            }
        }
    }
}