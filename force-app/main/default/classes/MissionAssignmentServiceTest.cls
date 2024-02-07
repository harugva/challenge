@isTest
public with sharing class MissionAssignmentServiceTest {

    @TestSetup
    static void setup(){
        Account account = new Account();
        account.Name = 'Portal Account';
        insert account;

        List<Contact> contacts = new List<Contact>();

        Contact contact = TestDataFactory.createContact();
        contact.AccountId = account.Id;
        contacts.add(contact);

        Contact contact2 = TestDataFactory.createContact();
        contact2.FirstName = 'Paul';
        contact2.LastName = 'Walker';
        contact2.AccountId = account.Id;
        contacts.add(contact2);

        insert contacts;

        List<User> portalUsers = new List<User>();

        User partnerUser = TestDataFactory.createPartnerUser();
        partnerUser.ContactId = contacts[0].Id;
        portalUsers.add(partnerUser);

        User partnerUser2 = TestDataFactory.createPartnerUser();
        partnerUser2.FirstName = 'Paul';
        partnerUser2.LastName = 'Walker';
        partnerUser2.Alias = 'PWalker';
        partnerUser2.Email = 'paul.walker@gmail.com.test';
        partnerUser2.Username = 'paul.walker@gmail.com.test';
        partnerUser2.ContactId = contacts[1].Id;
        portalUsers.add(partnerUser2);

        insert portalUsers;

        Guild__c guild = TestDataFactory.createGuild();
        insert guild;

        List<Hero__c> heroes = new List<Hero__c>();

        Hero__c heroDrink = new Hero__c();
        heroDrink.Guild__c = guild.Id;
        heroDrink.Contact__c = contacts[0].Id;
        heroes.add(heroDrink);

        Hero__c heroRacer = new Hero__c();
        heroRacer.Guild__c = guild.Id;
        heroRacer.Contact__c = contacts[1].Id;
        heroes.add(heroRacer);

        Superhero_Mission__c mission = TestDataFactory.createSuperheroMission();
        mission.Guild__c = guild.Id;
        insert mission;


        List<Mission_Assignment__c> assignments = new List<Mission_Assignment__c>();
        Mission_Assignment__c drinkAssignment = new Mission_Assignment__c();
        drinkAssignment.Mission__c = mission.Id;
        drinkAssignment.Hero__c = heroes[0].Id;
        assignments.add(drinkAssignment);

        Mission_Assignment__c racesAssignment = new Mission_Assignment__c();
        racesAssignment.Mission__c = mission.Id;
        racesAssignment.Hero__c = heroes[1].Id;
        assignments.add(racesAssignment);

        insert assignments;
    }

    @isTest
    static void testUpdateRelatedMissions(){
        Mission_Assignment__c assignment = [SELECT Status__c FROM Mission_Assignment__c LIMIT 1];
        assignment.Status__c = 'Completed';
        update assignment;

        Superhero_Mission__c mission = [SELECT Status__c FROM Superhero_Mission__c LIMIT 1];
        System.assertEquals('Completed', mission.Status__c, 'Expected mission status to be "Completed".');
    }

    @isTest
    static void testUpdateFailedAssignments(){
        Mission_Assignment__c assignment = [SELECT Status__c FROM Mission_Assignment__c LIMIT 1];
        assignment.Status__c = 'Completed';
        update assignment;

        Mission_Assignment__c failedAssignment = [SELECT Status__c FROM Mission_Assignment__c WHERE Id != : assignment.Id];
        System.assertEquals('Failed', failedAssignment.Status__c, 'Expected mission assignment status to be "Failed".');
    }
}