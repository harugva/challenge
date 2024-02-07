trigger MissionAssignmentTrigger on Mission_Assignment__c (after update) {
    TriggerTemplate.TriggerManager triggerManager = new TriggerTemplate.TriggerManager();
	triggerManager.addHandler(new MissionAssignmentTriggerHandler(), new List<TriggerTemplate.TriggerAction>{
        TriggerTemplate.TriggerAction.afterUpdate
    });

	triggerManager.runHandlers();
}