/**
* Author: Creation Technology Solutions
* Date: 10/01/2019
* Description: Class which inserts the error and warning to Application Error Log object
**/
public class ApplicationErrorLogEntry {
	ApplicationErrorLogEntry(){}
	//Method to insert new error into error log object 
	public static void insertApplicationErrorLogEntry(Exception thisException){
		Application_Error_Log__c newErrorLogEntry = new Application_Error_Log__c();
		newErrorLogEntry.Start_Time__c            = datetime.now();
		//newErrorLogEntry.End_Time__c            = datetime.now();
		newErrorLogEntry.User__c                  = UserInfo.getUserId();
		newErrorLogEntry.Error_Description__c	  = thisException.getCause() +':'+ thisException.getMessage();
		insert newErrorLogEntry;
	}	
}