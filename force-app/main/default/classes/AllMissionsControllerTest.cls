@isTest
public with sharing class AllMissionsControllerTest {

    @TestSetup
    static void setup(){
        Account account = new Account();
        account.Name = 'Portal Account';
        insert account;

        Contact contact = TestDataFactory.createContact();
        contact.AccountId = account.Id;
        insert contact;

        User partnerUser = TestDataFactory.createPartnerUser();
        partnerUser.ContactId = contact.Id;
        insert partnerUser;

        Guild__c guild = TestDataFactory.createGuild();
        insert guild;

        Guild__c bestGuild = TestDataFactory.createGuild();
        bestGuild.Name = 'private place';
        insert bestGuild;

        Hero__c hero = TestDataFactory.createHero();
        hero.Contact__c = contact.Id;
        hero.Guild__c = guild.Id;
        insert hero;
        
        List<Superhero_Mission__c> missions = new List<Superhero_Mission__c>();

        for (Integer i = 0; i < 5; i++) {
            Superhero_Mission__c guildMission = TestDataFactory.createSuperheroMission();
            guildMission.Guild__c = guild.Id;
            Superhero_Mission__c bestGuildMission = TestDataFactory.createSuperheroMission();
            bestGuildMission.Guild__c = bestGuild.Id;

            missions.add(guildMission);
            missions.add(bestGuildMission);
        }

        insert missions;
    }

    @isTest
    static void testIfAllPublic() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];
        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }
        System.assertEquals(10, superheroMissionWrappers.size(), 'Expected to retrieve 10 wrappers because all missions are public.');
    }

    @isTest
    static void testIfAllPrivate() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];
        List<Superhero_Mission__c> missions = [SELECT Is_Public__c FROM Superhero_Mission__c];
        for (Superhero_Mission__c mission : missions) {
            mission.Is_Public__c = false;
        }
        update missions;

        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.id);
        }
        System.assertEquals(5, superheroMissionWrappers.size(), 'Expected to retrieve 5 wrappers because only 5 missions are public.');
    }

    @isTest
    static void testIfBoth() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer' LIMIT 1];
        hero__c hero = [SELECT Id FROM Hero__c WHERE Contact__c = : partnerUser.ContactId];
        Guild__c bestGuild = [SELECT Id FROM Guild__c WHERE Name = 'private place' LIMIT 1];
        List<Superhero_Mission__c> missions = [SELECT Status__c FROM Superhero_Mission__c WHERE Guild__c = : bestGuild.Id];
        missions[0].Status__c = 'Completed';
        missions[3].Is_Public__c = false;
        missions[4].Is_Public__c = false;
        update missions;

        Mission_Assignment__c assignment = new Mission_Assignment__c();
        assignment.Hero__c = hero.Id;
        assignment.Mission__c = missions[1].Id;
        insert assignment;

        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }
        System.assertEquals(8, superheroMissionWrappers.size(), 'Expected to retrieve 8 wrappers because 2 missions are private.');
    }
}