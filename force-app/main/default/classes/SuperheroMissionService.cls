public with sharing class SuperheroMissionService {
    public static void afterInsert(List<Superhero_Mission__c> newSuperheroMissions) {
        sendEmailsToHeroes(newSuperheroMissions);
    }

    private static void sendEmailsToHeroes(List<Superhero_Mission__c> newSuperheroMissions) {
        List<Superhero_Mission__c> publicMissions = new List<Superhero_Mission__c>();
        List<Superhero_Mission__c> privateMissions = new List<Superhero_Mission__c>();

        for (Superhero_Mission__c mission : newSuperheroMissions) {
            if (mission.Is_Public__c) {
                publicMissions.add(mission);
            } else {
                privateMissions.add(mission);
            }
        }

        if (publicMissions != null && !publicMissions.isEmpty()) {
            Database.executeBatch(new HeroicDispatchBatch(HeroicDispatchBatch.Mode.PUBLIC_MISSION, publicMissions));
        }
        if (privateMissions != null && !privateMissions.isEmpty()) {
            Database.executeBatch(new HeroicDispatchBatch(HeroicDispatchBatch.Mode.PRIVATE_MISSION, privateMissions));
        }
    }
}