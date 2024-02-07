public with sharing class MissionAssignmentTriggerHandler implements TriggerTemplate.Handler {

    private List<Mission_Assignment__c> newValues;
	private Map<Id, Mission_Assignment__c> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues) {
		this.newValues = newValues;
		this.oldValues = (Map<Id, Mission_Assignment__c>) oldValues;
	}

    public void handle(TriggerTemplate.TriggerAction action) {
        if (action == TriggerTemplate.TriggerAction.afterUpdate) {
            MissionAssignmentService.afterUpdate(newValues, oldValues);
        }
    }
}