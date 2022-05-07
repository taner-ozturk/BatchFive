@RestResource(urlMapping = '/fetchallaccounts')
global class AccountRESTController {
    
    @HttpGet
    global static List<Account> queryAllAccounts() {
        
        /* URL =  https://demoorg9-dev-ed.my.salesforce.com/services/apexrest/fetchallaccounts?Type=Prospect&name=abc
         * host =
         * domain = https://demoorg9-dev-ed.lightning.force.com/
         * path = /services/apexrest/fetchallaccounts
         * search/params = type=Prospect
         */
        RestRequest reqInstance = RestContext.request; // Context Of Request
        Map<String, String> paramMap = reqInstance.params;
        
        String type = paramMap.get('type'); //Prospect
        String name = paramMap.get('name');

        if(accountId != null ) {

            return [SELECT Id, Name, Phone, Type FROM Account WHERE Id = :accountId AND Type=:type AND Name = :name];

        } else {

            return [SELECT Id, Name, Phone, Type FROM Account WHERE Type = :type AND Name = :name];
        }

        String basicQuery = 'SELECT Id, Name, Phone, Type FROM Account ';

        String accountId = null;

        if(accountId != null ) {

            basicQuery = basicQuery + ' WHERE Id = :accountId';
        }

        //Dynamic SOQL
        return Database.query(basicQuery);
    }

    @HttpPost
    global static void createAccount() {

        RestRequest reqInstance = RestContext.request;
        String jsonString = reqInstance.requestBody.toString();//converting the body to the json string

        //Type Casting JSON String to Wrapper Instance
        AccountWrapper wrapperInstance = (AccountWrapper) (JSON.deserialize(jsonString, AccountWrapper.class));

        Account accountInstance = new Account(
            Name = wrapperInstance.accountName,
            Type = wrapperInstance.accountType,
            Description = wrapperInstance.accountDescription
        );
        insert accountInstance;
    }

    public class AccountWrapper {

        public String accountName;
        public String accountType;
        public String accountDescription;
    }
}