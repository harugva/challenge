public with sharing class Utils {
    public static List<SObject> getModifiedRecords(List<String> fieldApiNames, List<SObject> newRecords, Map<Id, SObject> oldRecordsByIds) {
        List<SObject> modifiedRecords = new List<SObject>();
        for (SObject newRecord : newRecords) {
            Map<String, Schema.SObjectField> sObjectFieldsByApiNames = newRecord.getSObjectType().getDescribe().fields.getMap(); 
            SObject oldRecord = oldRecordsByIds.get(newRecord.Id);
            for (String fieldApiName :fieldApiNames) {
                if (sObjectFieldsByApiNames.containsKey(fieldApiName) && oldRecord.get(fieldApiName) != newRecord.get(fieldApiName)) {
                    modifiedRecords.add(newRecord);
                    break;
                }
            }
        }
        return modifiedRecords;
    }

    public static Set<Id> getRelatedIds(List<SObject> records, String relatedFieldApiName) {
        Set<Id> relatedIds = new set<Id>();
        for (SObject record : records) {
            Id relatedId = (Id)record.get(relatedFieldApiName);
            if (relatedId != null) {
                relatedIds.add(relatedId);
            }
        }
        return relatedIds;
    }

    public static void setFields(Map<String, Object> fieldValuesByApiNames, List<SObject> records) {
        for (SObject record : records) {
            Map<String, Schema.SObjectField> sObjectFieldsByApiNames = record.getSObjectType().getDescribe().fields.getMap();
            for (String fieldApiName : fieldValuesByApiNames.keySet()) {
                if (sObjectFieldsByApiNames.containsKey(fieldApiName)) {
                    record.put(fieldApiName, fieldValuesByApiNames.get(fieldApiName));
                }
            }
        }
    }
}