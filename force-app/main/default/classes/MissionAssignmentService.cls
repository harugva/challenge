public without sharing class MissionAssignmentService {
    public static void afterUpdate(List<Mission_Assignment__c> newAssignments, Map<Id, Mission_Assignment__c> oldAssignmentsByIds) {
        handleComletedMissions(newAssignments, oldAssignmentsByIds);
    }

    private static void handleComletedMissions(List<Mission_Assignment__c> newAssignments, Map<Id, Mission_Assignment__c> oldAssignmentsByIds) {
        List<Mission_Assignment__c> assignmentsWithModifiedFields = (List<Mission_Assignment__c>) Utils.getModifiedRecords(new List<String>{ 'Status__c' }, newAssignments, oldAssignmentsByIds);
        List<Mission_Assignment__c> completedAssignments = getCompletedAssignments(assignmentsWithModifiedFields);

        if (completedAssignments != null && !completedAssignments.isEmpty()) {
            Set<Id> relatedMissionIds = Utils.getRelatedIds(assignmentsWithModifiedFields, 'Mission__c');
            Set<Id> completedAssignmentsIds = Utils.getRelatedIds(completedAssignments, 'Id');

            updateRelatedMissions(relatedMissionIds);
            updateFailedAssignments(relatedMissionIds);
            new CompletedMissionDispatch(completedAssignmentsIds).sendEmails();
        }
    }

    private static void updateRelatedMissions(Set<Id> relatedMissionIds) {
        List<Superhero_Mission__c> relatedMissions = [SELECT Status__c FROM Superhero_Mission__c WHERE Id IN : relatedMissionIds];

        if (relatedMissions != null && !relatedMissions.isEmpty()) {
            Utils.setFields(new Map<String, Object>{
                'Status__c' => 'Completed'
            }, relatedMissions);

            update relatedMissions;
        }
    }

    private static void updateFailedAssignments(Set<Id> relatedMissionIds) {
        List<Mission_Assignment__c> failedAssignments = [SELECT Status__c FROM Mission_Assignment__c WHERE Mission__c IN : relatedMissionIds AND Status__c != 'Completed'];

        if (failedAssignments != null && !failedAssignments.isEmpty()) {
            Utils.setFields(new Map<String, Object>{
                'Status__c' => 'Failed'
            }, failedAssignments);

            update failedAssignments;
        }
    }

    private static List<Mission_Assignment__c> getCompletedAssignments(List<Mission_Assignment__c> assignmentsWithModifiedFields) {
        List<Mission_Assignment__c> completedAssignments = new List<Mission_Assignment__c>();
        for (Mission_Assignment__c assignment : assignmentsWithModifiedFields) {
            if (assignment.Status__c == 'Completed') {
                completedAssignments.add(assignment);
            }
        }
        return completedAssignments;
    }
}