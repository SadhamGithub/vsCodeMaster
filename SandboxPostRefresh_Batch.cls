/**
* Author: Natarajan Periyasamy, Creation Technology Solutions
* Date: 07/01/2019
* Description: Batch class to append email fields with .invalid
**/
global class SandboxPostRefresh_Batch implements Database.Batchable<sObject> {

    String query;
    String sObjectName;
    Map <String, List <String>> sObjectEmaiLFieldsMap = new Map <String, List <String>>();

    private SandboxPostRefresh_Batch(Map <String, List <String>> sObjectFieldsMap) {
        sObjectName = new List<String> (sObjectFieldsMap.keySet()).get(0);

        sObjectEmaiLFieldsMap = sObjectFieldsMap;
        query = SandboxPostRefreshHelper.getSOQLString(sObjectName, sObjectEmaiLFieldsMap.get(sObjectName));
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        for(sObject thisRecord : scope) {
            for(String thisField : sObjectEmaiLFieldsMap.get(sObjectName)) {
                String email = (String) thisRecord.get(thisField);
                if(String.isEmpty(email) || email.contains('.invalid') || email.contains('.noemail')) continue; 
                thisRecord.put(thisField, email + '.invalid'); 
            }
        }
        Database.update(scope, false); 
    }
    
    global void finish(Database.BatchableContext BC) {
        sObjectEmaiLFieldsMap.remove(sObjectName);
        executeBatch(sObjectEmaiLFieldsMap);
    }

    public static void executeBatch(Map <String, List <String>> sObjectFieldsMap) {
        if(!sObjectFieldsMap.isEmpty()) {
            Database.executeBatch(new SandboxPostRefresh_Batch(sObjectFieldsMap));
        }
    }
}