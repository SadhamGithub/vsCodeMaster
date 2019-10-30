/**
* Author: Natarajan Periyasamy, Creation Technology Solutions
* Date: 10/01/2019
* Description: Helper class to query the Sobject email fields
**/
public class SandboxPostRefreshHelper {
  /**
     * isSandbox - Determines whether the running org is sanbox or not.       
     * @return boolean              
    */

  public static Boolean isSandbox() {
        return [SELECT IsSandbox FROM Organization WHERE Id =: UserInfo.getOrganizationId()].IsSandbox;
    }
    /**
     * executeBatch - Call this method from the class that implements the SandboxPostCopy Interface or from Developer console.  
     * @return              
    */
    public static void executeBatch() {
        Map <String, List <String>> sObjectEmaiLFieldsMap = getsObjectEmaiLFields();
        SandboxPostRefresh_Batch.executeBatch(sObjectEmaiLFieldsMap);
        
    }
    /**
     * getSOQLString - it return the dynamic SOQL query based on sObjectName and sObjectFields  
     * @param  sObjectName 
     * @param  sObjectFields       
     * @return soqlQuery             
    */
    public static String getSOQLString(String sObjectName, List<String> sObjectFields) {
    
        String soqlQuery = 'SELECT {!sObjectFields} FROM {!objectTypeName} WHERE {!conditionals}';

        List<String> conditionals = new List <String>();
        for (String thisField: sObjectFields) { 
            conditionals.add(thisField + ' != NULL');
        }
        
        soqlQuery = soqlQuery.replace('{!sObjectFields}', String.join(sObjectFields, ' ,'));
        soqlQuery = soqlQuery.replace('{!objectTypeName}', sObjectName);
        soqlQuery = soqlQuery.replace('{!conditionals}', String.join(conditionals, ' OR '));

        if(!isSandbox() && !Test.isRunningTest()) soqlQuery = soqlQuery + ' LIMIT 0'; //For Non Sandbox (Production) Instance Do Not Update Records

        return soqlQuery;
    }

    /**
     * getsObjectEmaiLFields - It returns the list of all email fields and map to the corresponding Sobjects.  
     * @return sObjectEmailFieldMap             
    */
    public static Map <String, List <String>> getsObjectEmaiLFields() {

        Map <String, List <String>> sObjectEmailFieldMap = new Map <String, List <String>>();

        //Only pass the selected object, dynamically getting all objects may exceed APEX CPU Limit
        List<SObjectType> sObjectsToUpdate = new List<SObjectType>{ Account.SObjectType, 
                                                                    Contact.SObjectType, 
                                                                    Case.SObjectType, 
                                                                    CampaignMember.SObjectType, 
                                                                    Lead.SObjectType, 
                                                                    Opportunity.SObjectType, 
                                                                    Quote.SObjectType };

        for(SObjectType sObjectType : sObjectsToUpdate) {

            //Describe sObject
            DescribeSObjectResult sObjectDescribe = sObjectType.getDescribe();

            String objectTypeName = sObjectDescribe.getName();
            
            //Skip objects we cannot query or update
            if(!sObjectDescribe.isQueryable() || !sObjectDescribe.isUpdateable()) continue;
            
            for(SObjectField sObjectField: sObjectDescribe.fields.getMap().values()) {

                DescribeFieldResult thisField = sObjectField.getDescribe();
                
                //Skip all non email fields
                if(thisField.getType() != Schema.DisplayType.EMAIL || !thisField.isFilterable() || !thisField.isUpdateable()) continue;
                
                if(sObjectEmailFieldMap.containsKey(objectTypeName)) {
                    sObjectEmailFieldMap.get(objectTypeName).add(thisField.getName());
                }
                else {
                    sObjectEmailFieldMap.put(objectTypeName, new List <String> {thisField.getName()});
                }
            }
        }
        return sObjectEmailFieldMap;
    }
}