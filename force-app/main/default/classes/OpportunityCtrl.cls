public with sharing class OpportunityCtrl {
    //get all the opps whose stage matches with the given
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOppsByStage(String stage) {
        return [SELECT Name, Type, Amount, StageName
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

}