/**
 * 
 */
public with sharing class TriggerFactory
{
    public static void initiateHandler(Schema.sObjectType soType)
    {
        Trigger_conf__c triggerConfig = Trigger_conf__c.getInstance(soType + '');
        if(triggerConfig != null && 
            isTriggerDisabledForUser(triggerConfig) == false){
                
            TriggerInterface handler = getHandler(triggerConfig);
            
            if (handler != null)
            {
                execute(handler);
            }
        }
    }

    private static Boolean isTriggerDisabledForUser(Trigger_conf__c config){
        return (String.IsNotBlank(config.SkipTriggerUsernames__c) &&
                config.SkipTriggerUsernames__c.containsIgnoreCase(UserInfo.getUserName())) ;
    }

    private static void execute(TriggerInterface handler)
    {

        if (Trigger.isBefore)
        {   
            if (Trigger.isDelete)
            {
                handler.beforeDelete(Trigger.old);
            }
            else if (Trigger.isInsert)
            {
                handler.beforeInsert(Trigger.new);
            }
            else if (Trigger.isUpdate)
            {
                handler.beforeUpdate(Trigger.new, Trigger.oldmap);
            }
        }
        else
        {
            if (Trigger.isDelete)
            {
                    handler.afterDelete(Trigger.old);
            }
            else if (Trigger.isInsert)
            {
                handler.afterInsert(Trigger.new);
            }
            else if (Trigger.isUpdate)
            {
                handler.afterUpdate(Trigger.new, Trigger.oldmap);
            }
        }
    }

    private static TriggerInterface getHandler(Trigger_conf__c config)
    {
        TriggerInterface handler;

        if(String.isNotBlank(config.TiggerHandlerClass__c)){
            Type t = Type.forName(config.TiggerHandlerClass__c);

            Object typeInstance = t.newInstance();
            
            if(t != null && typeInstance instanceof TriggerInterface){
                handler = (TriggerInterface) typeInstance;
            }
            else{
                system.debug('WARNING: Handler ' + config.TiggerHandlerClass__c + ' for Sobject ' + config.name + ' does not inherit IHandler interface');
            }
        }

        return handler; 
    }
}