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

    public static void checkContactAndCreate(String contactEmail) {

        HttpRequest request = new HttpRequest(); //Request Instance
        request.setEndPoint('https://gorest.co.in/public/v2/users?email=' + contactEmail);
        request.setMethod('GET');


        Http httpInstance = new Http(); //Http Protocol

        HttpResponse response =  httpInstance.send(request); // Response Instance

        //Check If Request is success or not
        if(response.getStatusCode() == 200) {

            System.debug('Success Response:' + response.getBody());

            //Deserailising the response body to the  list of wrapper 
            List<UsersWrapper> userList = (List<UsersWrapper>) (JSON.deserialize(response.getBody(), List<UsersWrapper>.class));

            //Declaring list of contact to insert contacts
            List<Contact> contactToUpdateList = new List<Contact>();

            //Iterating through list of users wrapper to preapre a contact instance
            for(UsersWrapper wrapperInstance : userList) {

                //Constructing contact instance with wrapper instance
                Contact contactInstance = new Contact(
                    LastName = wrapperInstance.name,
                    Email = wrapperInstance.email
                );

                //Adding contact instance to the list to insert
                contactToUpdateList.add(contactInstance);
            }

            //Inserting contacts with response 
            insert contactToUpdateList;
        } else {
            System.debug('Error Response:' + response.getStatus());
        }
    }

    public static void createUserInGoREST(String name, String contactEmail, String gender, String status) {

        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://gorest.co.in/public/v2/users');
        request.setMethod('POST');

        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer c5ff3f7380584bbe6f6f5599c36a3d9859263f4a774de7454e27ffdbfc7aeae3');

        UsersWrapper wrapperInstance = new UsersWrapper();
        wrapperInstance.name = name;
        wrapperInstance.email = contactEmail;
        wrapperInstance.gender = gender;
        wrapperInstance.status = status;

        String jsonString = JSON.serialize(wrapperInstance);
        request.setBody(jsonString);

        Http httpInstance = new Http();

        HttpResponse response = httpInstance.send(request);
        System.debug('Status Code:'+ response.getStatusCode());
        if(response.getStatusCode() == 201) {
            UsersWrapper responseWrapper = (UsersWrapper) (JSON.deserialize(response.getBody(), UsersWrapper.class));
            System.debug('responseWrapper:' + responseWrapper);
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