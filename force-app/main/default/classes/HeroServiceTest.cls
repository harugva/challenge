@isTest
public with sharing class HeroServiceTest {

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
    }

    @isTest
    static void testCheckRelatedContactPositive() {
        Guild__c guild = [SELECT Id FROM Guild__c WHERE Name = 'Safe space' LIMIT 1];
        Contact contact = [SELECT Id FROM Contact WHERE Name = 'John Beer' LIMIT 1];

        Hero__c hero = new Hero__c();
        hero.Name = 'Drink';
        hero.Guild__c = guild.Id;
        hero.Contact__c = contact.Id;

        insert hero;

        hero = [SELECT Name FROM Hero__c LIMIT 1];
        Assert.isNotNull(hero, 'Expected hero not to be null');
        Assert.areEqual('Drink', hero.Name, 'Expected hero name to be "Drink".');

        contact = [SELECT Id FROM Contact WHERE Name = 'Paul Walker' LIMIT 1];
        hero.Contact__c = contact.Id;
        hero.Name = 'Racer';
        update hero;

        hero = [SELECT Name FROM Hero__c LIMIT 1];
        Assert.isNotNull(hero, 'Expected hero not to be null');
        Assert.areEqual('Racer', hero.Name, 'Expected hero name to be "Racer".');
    }

    @isTest
    static void testCheckRelatedContactNegative() {
        Guild__c guild = [SELECT Id FROM Guild__c WHERE Name = 'Safe space' LIMIT 1];
        Contact contact = new Contact();
        contact.FirstName = 'Ben';
        contact.Lastname = 'Botton';
        insert contact;

        Hero__c hero = new Hero__c();
        hero.Name = 'Child';
        hero.Guild__c = guild.Id;
        hero.Contact__c = contact.Id;

        try {
            insert hero;
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Related Contact must be a Portal User.'), 'Expected an error to be thrown.');
        }

        contact = [SELECT Id FROM Contact WHERE Name = 'John Beer' LIMIT 1];
        hero.Contact__c = contact.Id;
        hero.Name = 'Drink';
        insert hero;

        hero = [SELECT Name FROM Hero__c LIMIT 1];
        Assert.isNotNull(hero, 'Expected hero not to be null');
        Assert.areEqual('Drink', hero.Name, 'Expected hero name to be "Drink".');

        contact = [SELECT Id FROM Contact WHERE Name = 'Ben Botton' LIMIT 1];
        hero.Contact__c = contact.Id;
        hero.Name = 'Child';

        try {
            update hero;
        } catch (Exception e) {
            Assert.isTrue(e.getMessage().contains('Related Contact must be a Portal User.'), 'Expected an error to be thrown.');
        }
    }
}