public with sharing class OpportunityCtrl {
    //get all the opps whose stage matches with the given
    @AuraEnabled
    public static List<Opportunity> getOppsByStage(String stage) {
        return [SELECT Name, Type, Amount, StageName, CloseDate
                FROM Opportunity
                WHERE StageName = :stage
                WITH SECURITY_ENFORCED
                LIMIT 10];
    }

    //get all the opps whose type matches with the given input
    @AuraEnabled
    public static List<Opportunity> getOppsByType(String type) {
        return [SELECT Name, Type, Amount, StageName
                FROM Opportunity
                WHERE Type = :type
                WITH SECURITY_ENFORCED
                LIMIT 10];
    }

    //calculate the total amounts of all opps under the given account
    @AuraEnabled
    public static Decimal calculateOppAmount(Id accountId) {
        Decimal total = 0.0;
        for(Opportunity opp:[SELECT Id, Amount FROM Opportunity WHERE AccountId =:accountId WITH SECURITY_ENFORCED]){
            if (opp.Amount != null){
                 total=total + opp.Amount;
            }
        }
        return total;
    }
}