public without sharing class MissionDetailController {
    @AuraEnabled
    public static void applyMission(AllMissionsController.SuperheroMissionWrapper missionWrapper){
        try {
            checkRank(missionWrapper);
            checkAssignments(missionWrapper);
            
            Mission_Assignment__c missionAssignment = new Mission_Assignment__c();
            missionAssignment.Hero__c = missionWrapper.heroId;
            missionAssignment.Mission__c = missionWrapper.missionId;
            insert missionAssignment;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void completeMission(AllMissionsController.SuperheroMissionWrapper missionWrapper){
        try {
            Mission_Assignment__c missionAssignment = new Mission_Assignment__c(Id = missionWrapper.missionAssignmentId);
            missionAssignment.Status__c = 'Completed';
            update missionAssignment;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static void checkRank(AllMissionsController.SuperheroMissionWrapper missionWrapper) {
        Map<String, Integer> intRanksByStringRanks = new Map<String, Integer>{
            'S' => 4,
            'A' => 3,
            'B' => 2,
            'C' => 1,
            'D' => 0
        };

        Integer intHeroRank = intRanksByStringRanks.get(missionWrapper.heroRank);
        Integer intMissionRank = intRanksByStringRanks.get(missionWrapper.missionRank);

        if (Math.abs(intHeroRank - intMissionRank) >= 2) {
            String errorMessage = (intHeroRank > intMissionRank) ? 'This mission is too easy for you!' : 'This mission is too dangerous for you!';
            throw new HeroMissionException(errorMessage);
        }
    }

    private static void checkAssignments(AllMissionsController.SuperheroMissionWrapper missionWrapper) {
        List<Mission_Assignment__c> assignments = [SELECT Id, Status__c FROM Mission_Assignment__c WHERE Hero__c = : missionWrapper.heroId AND Status__c != 'Completed'];

        if (assignments != null && assignments.size() >= 3) {
            throw new HeroMissionException('You can not take this mission because you already have 3. Complete them and come back my dude.');
        }
    }
}