public interface TriggerInterface {
    void beforeInsert(List<SObject> newSO);
    void beforeUpdate(List<Sobject> newSO, Map<Id,Sobject> oldMap);
    void beforeDelete(List<SObject> oldSO);
    void afterInsert(List<SObject> newSO);
    void afterUpdate(List<Sobject> newSO, Map<Id,Sobject> oldMap);
    void afterDelete(List<SObject> oldSO);
}