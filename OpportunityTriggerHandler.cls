/**
 * Author : Natarajan Periyasamy
 * Date: DD/MM/YYYY
 * Description: Opportunity Trigger Handler Methods
 */
public with sharing class OpportunityTriggerHandler extends TriggerHandler.TriggerHandlerBase {

    static Set<Id> recordIds;
    static Integer recursionCount = 1;
    
    //To recursively execute the code in the same transaction, set this variable to true
    public static Boolean runOnce = true; 
   
    public override void beforeInsert(List<SObject> lstNewSObjs) {
    
    }

	public override void afterUpdate(Map<Id,SObject> mapOldSObjs, Map<Id,SObject> mapNewSObjs) {
        runOnce = false;
	} 

    //Recursive Check 
    public static Boolean recursiveCheck(Map<Id, sObject> mapNewSObjs) {
        //For Insert Return True
        if(mapNewSObjs == null) { return true; }
        //For Update - Return False For WorkFlow Field Update / Process Builder Update
        else if(recordIds != null 
                && recordIds.containsAll(mapNewSObjs.keySet()) 
                && recursionCount > 2) {
            return runOnce == true ? true : false;
        }
        else {
            recordIds = new Set<Id>();
            recursionCount = math.mod(recursionCount, 2) != 0 ? 1 : recursionCount;
            recursionCount++;
            recordIds.addAll(mapNewSObjs.keySet());
            return true;
        }
    }
}