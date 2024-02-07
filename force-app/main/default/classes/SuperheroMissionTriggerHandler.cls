public with sharing class SuperheroMissionTriggerHandler implements TriggerTemplate.Handler {

    private List<Superhero_Mission__c> newValues;
	private Map<Id, Superhero_Mission__c> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues) {
		this.newValues = newValues;
		this.oldValues = (Map<Id, Superhero_Mission__c>) oldValues;
	}

    public void handle(TriggerTemplate.TriggerAction action) {
        if (action == TriggerTemplate.TriggerAction.afterInsert) {
            SuperheroMissionService.afterInsert(newValues);
        }
    }
}