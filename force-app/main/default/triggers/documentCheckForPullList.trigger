trigger documentCheckForPullList on Attachment (after insert, after update) {

List<ID> PullListIds = New List<ID>();
  
    for(Attachment o : Trigger.new){
  
    PullListIds.add(o.ParentId);

    List<Pull_list__c> pullList = [SELECT id, Name, DocumentAdded__c FROM Pull_list__c WHERE id in :PullListIds];
   
    for(integer i = 0 ; i < pullList.size(); i++){
        pullList[i].DocumentAdded__c = true;
      }
  
    update pullList;
    
    }
}