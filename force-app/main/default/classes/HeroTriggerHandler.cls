public with sharing class HeroTriggerHandler implements TriggerTemplate.Handler {
    private List<Hero__c> newValues;
	private Map<Id, Hero__c> oldValues;

    public void setValues(List<sObject> newValues, Map<Id, sObject> oldValues) {
		this.newValues = newValues;
		this.oldValues = (Map<Id, Hero__c>) oldValues;
	}

    public void handle(TriggerTemplate.TriggerAction action) {
        if (action == TriggerTemplate.TriggerAction.beforeInsert) {
            HeroService.beforeInsert(newValues);
        }
        if (action == TriggerTemplate.TriggerAction.beforeUpdate) {
            HeroService.beforeUpdate(newValues, oldValues);
        }
    }
}