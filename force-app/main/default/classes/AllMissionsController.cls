public without sharing class AllMissionsController {
    @AuraEnabled
    public static List<SuperheroMissionWrapper> getSuperheroMissions(Id userId) {
        Id contactId = getContactId(userId);
        Hero__c hero = [SELECT Guild__c, Rank__c, Contact__c FROM Hero__c WHERE Contact__c = : contactId LIMIT 1];
    
        List<Superhero_Mission__c> missions = [
            SELECT Id, Name, Complexity_Rank__c, Guild__r.Name, Status__c, Details__c, Subject__c, Reward__c, Deadline__c,
                (SELECT Mission__c, Status__c, Hero__c, Hero__r.Contact__c FROM Mission_Assignments__r WHERE Hero__c = : hero.Id)
            FROM Superhero_Mission__c 
            WHERE Is_Public__c = true OR Guild__c = : hero.Guild__c
            ORDER BY CreatedDate DESC
        ];

        return getSuperheroMissionWrappers(missions, hero);
    }

    private static Id getContactId(Id userId) {
        return [SELECT ContactId, Name FROM User WHERE Id = : userId LIMIT 1].ContactId;
    }

    private static List<SuperheroMissionWrapper> getSuperheroMissionWrappers(List<Superhero_Mission__c> missions, Hero__c hero) {
        List<SuperheroMissionWrapper> superheroMissionWrappers = new List<SuperheroMissionWrapper>();

        for (Superhero_Mission__c mission : missions) {
            SuperheroMissionWrapper missionWrapper = new SuperheroMissionWrapper();
            
            if (mission.Mission_Assignments__r != null && !mission.Mission_Assignments__r.isEmpty()) {
                Mission_Assignment__c missionAssignment = mission.Mission_Assignments__r[0];

                missionWrapper.missionAssignmentId = missionAssignment.Id;
                missionWrapper.assignmentStatus = missionAssignment.Status__c;
            }

            missionWrapper.heroId = hero.Id;
            missionWrapper.heroRank = hero.Rank__c;
            missionWrapper.missionId = mission.Id;
            missionWrapper.missionRank = mission.Complexity_Rank__c;
            missionWrapper.subject = mission.Subject__c;
            missionWrapper.guildName = mission.Guild__r.Name;
            missionWrapper.missionStatus = mission.Status__c;
            missionWrapper.details = mission.Details__c;
            missionWrapper.reward = mission.Reward__c;
            missionWrapper.deadline = mission.Deadline__c;

            if (missionWrapper.missionStatus == 'Completed') {
                missionWrapper.status = 'Completed';
            } else if (missionWrapper.missionStatus == 'Uncompleted' && missionWrapper.assignmentStatus == 'In progress') {
                missionWrapper.status = 'In progress';
            } else {
                missionWrapper.status = 'Available';
            }

            superheroMissionWrappers.add(missionWrapper);
        }

        return superheroMissionWrappers;
    }

    public without sharing class SuperheroMissionWrapper {
        @AuraEnabled
        public Id heroId { get; set; }
        @AuraEnabled
        public Id missionAssignmentId { get; set; }
        @AuraEnabled
        public String assignmentStatus { get; set;}

        @AuraEnabled
        public Id missionId { get; set; }
        @AuraEnabled
        public String missionRank { get; set; }
        @AuraEnabled
        public String subject { get; set; }
        @AuraEnabled
        public String guildName { get; set; }
        @AuraEnabled
        public String missionStatus { get; set; }
        @AuraEnabled
        public String details { get; set; }
        @AuraEnabled
        public Double reward { get; set; }
        @AuraEnabled
        public Date deadline { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public String heroRank { get; set; }
    }
}