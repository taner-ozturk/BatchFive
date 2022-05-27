public with sharing class AccountCtrl {

    //get top 10 accounts based on annual revenue
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Type, Industry, AnnualRevenue
            FROM Account
            WHERE AnnualRevenue != null
            WITH SECURITY_ENFORCED
            ORDER BY AnnualRevenue DESC
            LIMIT 10];
    }

    //get all the accounts whose type matches with the given type
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByType(String type) {
        return [SELECT Name, Type, Industry, AnnualRevenue
                FROM Account
                WHERE Type LIKE :type
                WITH SECURITY_ENFORCED
                LIMIT 10];
    }

    //get all the accounts whose name contains the given search key
    @AuraEnabled
    public static List<Account> searchAccounts(String searchKey) { //est
        searchKey = '%' + searchKey + '%'; // %est%
        return [SELECT Id, Name, Type, Industry, AnnualRevenue, AccountNumber
                FROM Account
                WHERE Name LIKE :searchKey
                WITH SECURITY_ENFORCED];
    }

}