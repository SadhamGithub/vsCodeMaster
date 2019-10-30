//To Update Sobject Records 

global class SObjectMassUpdate_Batch  implements Database.Batchable<sObject> {
    List<sObject> sObjectList = new List<sObject>();
    global SObjectMassUpdate_Batch(List<sObject> sObjectList){
        this.sObjectList = sObjectList;
    }
    global List<sObject> start(Database.BatchableContext BC) {
        return sObjectList;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}