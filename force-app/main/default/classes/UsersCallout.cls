public with sharing class UsersCallout {
    
    public static void fetchAllUsers() {

        //Request Instance
        HttpRequest request = new HttpRequest(); //request 
        request.setEndPoint('https://gorest.co.in/public/v2/users'); // is to set the callout endpoint url
        request.setMethod('GET'); //specifies what type of callout it is, POST, GET, DELETE

        Http httpInstance = new Http(); // http protocol

        HttpResponse response = httpInstance.send(request);  // request will be sent to the specified end point
        // response will be recieved to the response isnatnce

        System.debug('Status:' + response.getStatus());
        System.debug('Status Code:' + response.getStatusCode()); 

        System.debug('Response:' + response.getBody());

      if(response.getStatusCode() == 200 ) {

            //Converting JSON response to the UsersWrapper
            List<UsersWrapper> userList = (List<UsersWrapper>) (JSON.deserialize(response.getBody(), List<UsersWrapper>.class));

            System.debug('wrapperInstance Response:' + userList);
        } else {
            System.debug('Error Occurred:' + response.getStatus());
        }
    }

    //Wrapper Class to hold the users from the response
    private class UsersWrapper {
        private Integer id;
        private String name;
        private String email;
        private String gender;
        private String status;
    } 
}