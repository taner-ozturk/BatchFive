public class SFDC_WS_Integrations {

    public static void getCurrentWeatherInfo(String cityName) { //null or ''
        if (cityName != null && String.isNotBlank(cityName)) { //'New York'
            //http://api.weatherstack.com/current?access_key=20c6117f71296922194745f7856d3f74&query=New%20York
            //String endPoint2 = 'http://api.weatherstack.com/current?access_key=253896baf7b30004d2ae899d98f69271&query='+cityName;

            String endPoint = 'http://api.weatherstack.com/current?access_key='+System.Label.WhetherStackAPIKey+'&query='+cityName;
            
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
                
                SFDC_WS_Response resp = SFDC_WS_Response.parse(response.getBody());
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::query ' + resp.request.query);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::temperature ' + resp.current.temperature);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::weather_icons ' + resp.current.weather_icons[0]);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::humidity ' + resp.current.humidity);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo::timezone_id ' + resp.location.timezone_id);
                
                SFDC_WS_Response2 resp2 = (SFDC_WS_Response2) System.JSON.deserialize(response.getBody(), SFDC_WS_Response2.class);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo2::query ' + resp2.request.query);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo2::temperature ' + resp2.current.temperature);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo2::weather_icons ' + resp2.current.weather_icons[0]);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo2::humidity ' + resp2.current.humidity);
                System.debug('SFDC_WS_Integration::getCurrentWeatherInfo2::timezone_id ' + resp2.location.timezone_id);
            }
        }
    }
}
