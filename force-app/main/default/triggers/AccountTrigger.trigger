trigger AccountTrigger on Account (before insert,before update, after insert,after update,before delete,after delete) {
    TriggerFactory.initiateHandler(Account.sObjectType);
}