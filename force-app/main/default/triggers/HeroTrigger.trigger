trigger HeroTrigger on Hero__c (before insert, before update) {
    TriggerTemplate.TriggerManager triggerManager = new TriggerTemplate.TriggerManager();
	triggerManager.addHandler(new HeroTriggerHandler(), new List<TriggerTemplate.TriggerAction>{
        TriggerTemplate.TriggerAction.beforeInsert,
        TriggerTemplate.TriggerAction.beforeUpdate
	});

	triggerManager.runHandlers();
}