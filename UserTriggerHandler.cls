/**
 * @Author          Creation Technology Solutions
 * @name            UserTriggerHandler
 * @description     Apex handler class for User Trigger.
 */
public class UserTriggerHandler extends TriggerHandler.TriggerHandlerBase {

	public override void beforeUpdate(Map<Id,SObject> mapOldSObjs, Map<Id,SObject> mapNewSObjs) {
        Map<Id, User> userOldMap = (Map<Id, User>)mapOldSObjs;
        Map<Id, User> userNewMap = (Map<Id, User>)mapNewSObjs;
		
		deleteManagedPackageLicense(userOldMap, userNewMap);
	}
	/**
 		* @param          userOldMap, userNewMap
 		* @description    method to revoke all the inactive user's managed package license
 		* @return    
 	*/
	private void deleteManagedPackageLicense( Map<Id, User> userOldMap, Map<Id, User> userNewMap){
		Set<Id> userIds = new Set<Id>();

		for(User thisUser : userNewMap.values()){
			if(thisUser.IsActive != userOldMap.get(thisUser.Id).IsActive
				&& thisUser.IsActive == false){
				userIds.add(thisUser.Id);
			}
		}
		if(!userIds.isEmpty()){
			delete [SELECT Id FROM UserPackageLicense WHERE UserId IN : userIds];
		}
	} 

}