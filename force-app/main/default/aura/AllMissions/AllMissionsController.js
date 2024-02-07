({
    doInit: function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);

        helper.getSuperheroMissions(component);
    },

    showRow: function(component,event,helper){
        var selectedMissionId = event.currentTarget.getAttribute("data-myid");

        var selectedMission = component.get("v.data").find(function(rowData) {
            return rowData.missionId === selectedMissionId;
        });
        
        component.set("v.selectedMission", selectedMission);

        var payload = {
            recordId: selectedMissionId,
            recordData: selectedMission
        };

        var messageChannel = component.find("allMissionMessageChannel");
        messageChannel.publish(payload);
    },

    handleChanged: function(component, event, helper) {
        helper.getSuperheroMissions(component);
     }
})