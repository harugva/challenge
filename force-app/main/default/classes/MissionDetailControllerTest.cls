@isTest
public with sharing class MissionDetailControllerTest {

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

        Hero__c hero = TestDataFactory.createHero();
        hero.Contact__c = contact.Id;
        hero.Guild__c = guild.Id;
        insert hero;

        List<Superhero_Mission__c> missions = new List<Superhero_Mission__c>();

        for (Integer i = 0; i < 5; i++) {
            Superhero_Mission__c mission = TestDataFactory.createSuperheroMission();
            mission.Guild__c = guild.Id;
            missions.add(mission);
        }

        insert missions;
    }

    @isTest
    static void testApplyMissionPositive() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];
        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }
        MissionDetailController.applyMission(superheroMissionWrappers[0]);
        
        Mission_Assignment__c assignment = [SELECT Id FROM Mission_Assignment__c LIMIT 1];
        Assert.isNotNull(assignment, 'Expected one assignment to be cretaed.');
    }

    @isTest
    static void testApplyMissionNegativeRank() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];
        Hero__c hero = [SELECT Rank__c FROM Hero__c LIMIT 1];
        hero.Rank__c = 'S';
        update hero;

        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }

        try {
            MissionDetailController.applyMission(superheroMissionWrappers[0]);
        } catch (Exception e) {
            Assert.isNotNull(e);
        }
    }

    @isTest
    static void testCheckAssignmentNegative() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];
        Hero__c hero = [SELECT Rank__c FROM Hero__c LIMIT 1];

        List<Mission_Assignment__c>  assignments = new List<Mission_Assignment__c>();
        List<Superhero_Mission__c> missions = [SELECT Id FROM Superhero_Mission__c LIMIT 3];

        for (Superhero_Mission__c mission : missions) {
            Mission_Assignment__c assignment = new Mission_Assignment__c();
            assignment.Mission__c = mission.Id;
            assignment.Hero__c = hero.Id;
            assignments.add(assignment);
        }

        insert assignments; 

        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }

        try {
            MissionDetailController.applyMission(superheroMissionWrappers[4]);
        } catch (Exception e) {
            Assert.isNotNull(e);
        }
    }

    @isTest 
    static void testCompleteMissionPositive() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];
        Hero__c hero = [SELECT Rank__c FROM Hero__c LIMIT 1];

        List<Superhero_Mission__c> missions = [SELECT Id FROM Superhero_Mission__c LIMIT 4];
        delete missions;

        Superhero_Mission__c mission = [SELECT Id FROM Superhero_Mission__c LIMIT 1];

        Mission_Assignment__c assignment = new Mission_Assignment__c();
        assignment.Mission__c = mission.Id;
        assignment.Hero__c = hero.Id;
        assignment.Status__c = 'In progress';
        insert assignment; 

        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }

        MissionDetailController.completeMission(superheroMissionWrappers[0]);

        assignment = [SELECT Id, Status__c FROM Mission_Assignment__c LIMIT 1];
        Assert.isNotNull(assignment, 'Expected one assignment to be cretaed.');
        Assert.areEqual('Completed', assignment.Status__c, 'Expected assignment status to be "Completed".');
    }

    @isTest 
    static void testCompleteMissionNegative() {
        User partnerUser = [SELECT Id, ContactId FROM User WHERE Alias = 'JBeer'];

        List<AllMissionsController.SuperheroMissionWrapper> superheroMissionWrappers = new List<AllMissionsController.SuperheroMissionWrapper>();

        System.runAs(partnerUser) {
            superheroMissionWrappers = AllMissionsController.getSuperheroMissions(partnerUser.Id);
        }

        try {
            MissionDetailController.completeMission(superheroMissionWrappers[0]);
        } catch (Exception e) {
            Assert.isNotNull(e);
        }
    }
}