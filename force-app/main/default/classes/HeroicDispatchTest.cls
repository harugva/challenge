@isTest
public with sharing class HeroicDispatchTest {

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

        Guild__c bestGuild = TestDataFactory.createGuild();
        bestGuild.Name = 'private place';
        insert bestGuild;

        List<Hero__c> heroes = new List<Hero__c>();

        Hero__c heroGuild = TestDataFactory.createHero();
        heroGuild.Contact__c = contacts[0].Id;
        heroGuild.Guild__c = guild.Id;
        heroes.add(heroGuild);

        Hero__c heroBestGuild = TestDataFactory.createHero();
        heroBestGuild.Contact__c = contacts[1].Id;
        heroBestGuild.Guild__c = bestGuild.Id;
        heroes.add(heroBestGuild);

        insert heroes;
    }

    @isTest
    static void testSendEmailsWhenPublicMission(){
        Guild__c guild = [SELECT Id FROM Guild__c WHERE Name = 'Safe space' LIMIT 1];

        List<Superhero_Mission__c> missions = new List<Superhero_Mission__c>();
        for (Integer i = 0; i < 5; i++) {
            Superhero_Mission__c mission = TestDataFactory.createSuperheroMission();
            mission.Guild__c = guild.Id;
            missions.add(mission);
        }

        Test.startTest();
        insert missions;
        Test.stopTest();

        System.assertEquals(10, HeroicDispatch.emailCount, 'Expected 10 emails to be sent because missions are public.');
    }

    @isTest
    static void testSendEmailsWhenPrivateMission(){
        Guild__c guild = [SELECT Id FROM Guild__c WHERE Name = 'Safe space' LIMIT 1];

        List<Superhero_Mission__c> missions = new List<Superhero_Mission__c>();
        for (Integer i = 0; i < 5; i++) {
            Superhero_Mission__c mission = TestDataFactory.createSuperheroMission();
            mission.Guild__c = guild.Id;
            mission.Is_Public__c = false;
            missions.add(mission);
        }

        Test.startTest();
        insert missions;
        Test.stopTest();
        
        System.assertEquals(5, HeroicDispatch.emailCount, 'Expected 5 emails to be sent because missions are private.');
    }
}