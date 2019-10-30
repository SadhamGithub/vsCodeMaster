/**
* Author: Creation Technology Solutions
* Date: 11/01/2019
* Description: Test Class for SObjectMassUpdate_Batch class.
**/
@isTest
private class SObjectMassUpdate_Batch_Test {
    // Single record update test
    public static testMethod void updateSingleRecords(){
        List<Account> accList = TestDataFactory.createAccount(1);
        insert accList;
        System.assertEquals('Anthony1',accList[0].Name);
        for(Account thisaccount : accList){
            thisaccount.Name = 'Anthony1 Update';
        }
        Test.startTest();
        Database.executebatch(new SObjectMassUpdate_Batch(accList));
        Test.stopTest();
        List<Account> updateAccList = [SELECT Id, Name From Account WHERE Id IN:accList];
        System.assertEquals('Anthony1 Update',updateAccList[0].Name);
        System.assertEquals(1,updateAccList.size());
    }
    // Bulk record update Test
    public static testMethod void updateBulkRecords(){
        List<Account> accList = TestDataFactory.createAccount(200);
        insert accList;
        System.assertEquals('Anthony1',accList[0].Name);
        for(Account thisaccount : accList){
            thisaccount.Name = 'Anthony1 Update';
        }
        Test.startTest();
        Database.executebatch(new SObjectMassUpdate_Batch(accList));
        Test.stopTest();
        List<Account> updateAccList = [SELECT Id, Name From Account WHERE Id IN:accList];
        System.assertEquals('Anthony1 Update',updateAccList[0].Name);
        System.assertEquals(200,updateAccList.size());
    }
}