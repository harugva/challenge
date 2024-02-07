({
    getSuperheroMissions : function(component) {
        var action = component.get("c.getSuperheroMissions");
        action.setParams({
            userId: component.get("v.userId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
                component.set("v.selectedMission", {});
            } else {
                console.error("Error retrieving Superhero Missions: " + state);
            }
        });

        $A.enqueueAction(action);
    }
})