/**
 * @File Name          : TriggerHandler.cls
 * @Description        : 
 * @Author             : Sadham
 * @Group              : 
 * @Last Modified By   : Creation Admin
 * @Last Modified On   : 10/30/2019, 7:46:00 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/30/2019   Sadham     Initial Version
**/
public class TriggerHandler {

    public static boolean isTriggerExecuted = false;

    /**
     * Abstract trigger handler with default implementations of all actions.
     * Other handlers can extend this class and will only need to overwrite the functions which are needed.
     * Default action is to simply return with no further action.
     */
    public abstract class TriggerHandlerBase implements iTriggerInterface {
        public virtual void beforeInsert(List<SObject> lstNewSObjs) { return; }
        public virtual void beforeUpdate(Map<Id,SObject> mapOldSObjs, Map<Id,SObject> mapNewSObjs) { return; }
        public virtual void beforeDelete(Map<Id,SObject> mapOldSObjs) { return; }

        public virtual void afterInsert(Map<Id,SObject> mapNewSObjs) { return; }
        public virtual void afterUpdate(Map<Id,SObject> mapOldSObjs, Map<Id,SObject> mapNewSObjs) { return; }
        public virtual void afterDelete(Map<Id,SObject> mapOldSObjs) { return; }
        public virtual void afterUnDelete(Map<Id,SObject> mapNewSObjs) { return; }
    }

    /**
     * private static method to get the named handler.
     * Arguments: Type t - Class of handler to instatiate
     * Returns: iTriggerInterface - A trigger handler if one exists or null.
     */
    private static iTriggerInterface getHandler(Type t) {
        // Instantiate the type
        Object o = t.newInstance();
 
        // if its not an instance of iTriggerInterface return null
        if (!(o instanceOf iTriggerInterface)) {    return null; }
 
        return (iTriggerInterface)o;
    }

    /**
     * Public static method to create and execute a trigger handler
     * Arguments: Type t - Type of handler to instatiate
     * Throws a TriggerHandlerException if no handler has been found.
     */
    
    public static void createAndExecuteHandler(Type t) {
        // Get a handler appropriate to the object being processed
        iTriggerInterface handler = getHandler(t);
        
        // Make sure we have a handler registered, new handlers must be registered in the getHandler method.
        if (handler == null) {  throw new TriggerHandlerException('No Trigger Handler found named: ' + t.getName()); }
        
        // Execute the handler to fulfil the trigger
        if(!isTriggerExecuted)
            execute(handler);
    }

    /**
     * Routes the request into the seperate functions of handler classes which implement the interface class
     * @param sObjectHandler Instance 
     */
    public static void execute(iTriggerInterface sObjectHandler) {
        
        if (!Trigger.isExecuting) return;

        if (Trigger.isBefore ) {
            if (Trigger.isInsert) {
                sObjectHandler.beforeInsert( Trigger.new );
            } else if (Trigger.isUpdate) {
                sObjectHandler.beforeUpdate( Trigger.oldMap, Trigger.newMap );
            } else if (Trigger.isDelete) {
                sObjectHandler.beforeDelete( Trigger.oldMap );
            }
        }
        else { 
            if (Trigger.isInsert) {
                sObjectHandler.afterInsert( Trigger.newMap );
            } else if (Trigger.isUpdate) {
                sObjectHandler.afterUpdate( Trigger.oldMap, Trigger.newMap );
            } else if (Trigger.isDelete) {
                sObjectHandler.afterDelete( Trigger.oldMap );
            } else if (Trigger.isUndelete) {
                sObjectHandler.afterUnDelete( Trigger.newMap );
            }
        }
    }

    /**
     * All trigger handlers will need to implement off iTriggerInterface
     * @description     Use the bulk methods to load maps, and query for related records. etc.
     *                  Use the non bulk to process each record in the trigger
     */
    
    public Interface iTriggerInterface {
        void beforeInsert(List<SObject> lstNewSObjs);
        void beforeUpdate(Map<Id,SObject> mapOldSObjs, Map<Id,SObject> mapNewSObjs);
        void beforeDelete(Map<Id,SObject> mapOldSObjs);

        void afterInsert(Map<Id,SObject> mapNewSObjs);
        void afterUpdate(Map<Id,SObject> mapOldSObjs, Map<Id,SObject> mapNewSObjs);
        void afterDelete(Map<Id,SObject> mapOldSObjs);
        void afterUnDelete(Map<Id,SObject> mapNewSObjs);
    }

    public class TriggerHandlerException extends Exception {}
}