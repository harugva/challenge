trigger SuperheroMissionTrigger on Superhero_Mission__c (after insert) {
    TriggerTemplate.TriggerManager triggerManager = new TriggerTemplate.TriggerManager();
	triggerManager.addHandler(new SuperheroMissionTriggerHandler(), new List<TriggerTemplate.TriggerAction>{
        TriggerTemplate.TriggerAction.afterInsert
	});

	triggerManager.runHandlers();
}