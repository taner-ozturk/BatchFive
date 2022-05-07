@RestResource(urlMapping = '/fetchAccountsAndChilds')
global with sharing class AccountsAndChildData {
    
    @HttpGet
    global static List<Account> fetchAllAccounts() {

        RestRequest reqInstance = RestContext.request;
        Map<String, String> paramMap = reqInstance.params;

        String accountType = paramMap.get('type'); //null

        //List<Account> accountList = new List<Account>();

        /* Typical SOQL writing */
        /* 
        if(String.isNotBlank(accountType) == true) {

            accountList = [SELECT id, Name ,Phone, Type,
                (SELECT id, name, email FROM contacts), 
                (SELECT id,name ,StageName ,CloseDate FROM Opportunities) 
                FROM Account WHERE Type =:accountType
            ];
        } else {
            accountList = [SELECT id, Name ,Phone, Type,
                (SELECT id, name, email FROM contacts), 
                (SELECT id,name ,StageName ,CloseDate FROM Opportunities) 
                FROM Account 
            ];
        } */


        String accountQueryString = 'SELECT id, Name ,Phone, Type, ' 
            + ' (SELECT id, name, email FROM contacts), '
            + ' (SELECT id,name ,StageName ,CloseDate FROM Opportunities) '
            + ' FROM Account';

        if(String.isNotBlank(accountType) == true) {
            accountQueryString = accountQueryString + ' WHERE Type = :accountType';
        }

        return Database.query(accountQueryString);
    }

    @HttpPost
    global static void createAccountAndChilds() {

        /*public static JSON2Apex parse(String json) {
            return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
        } */

        RestRequest reqInstance = RestContext.request; //Context

        String requestBody = reqInstance.requestBody.toString(); //Request Body In String format

        /* Deserialising the request body to the wrapper instance */
        AccountAndChildWrapper wrapperInstance = (AccountAndChildWrapper) 
            (JSON.deserialize(requestBody, AccountAndChildWrapper.class));
        
        if(wrapperInstance != null && wrapperInstance.account != null) {

            Account accountInstance = new Account(
                Name = wrapperInstance.account.name,
                Type = wrapperInstance.account.type,
                Phone = wrapperInstance.account.phone
            );

            insert accountInstance;

        }

    }

    public class AccountAndChildWrapper {
        public AccountWrapper account;
        public ContactWrapper contact;
        public OpportunityWrapper opportunity;
    }

    public class AccountWrapper {
        public String name;
        public String type;
        public String phone;
    }

    public class OpportunityWrapper {
        public String name;
        public String stageName;
        public String closeDate;
    }

    public class ContactWrapper {
        public String firstName;
        public String lastName;
        public String email;
    }
}

        //How we will be getting parent account value from contact
        /* 
        contactInstance.Account.Name
        */
        /* Sample Request Body */
        /*
        {
            "account" : {
                "name" : "abc",
                "type" : "asa",
                "phone" : "8765"
            },
            "contact" : {
                "firstname" : "first",
                "lastname" : "last",
                "email" : "test@test"
            }, 
            "opportunity" : {
                "name" : "tey",
                "stageName" : "Closed",
                "closeDate" : "6754678"
            }
        }
        */