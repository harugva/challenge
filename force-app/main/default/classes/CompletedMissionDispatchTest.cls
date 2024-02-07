@isTest
public with sharing class CompletedMissionDispatchTest {

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

        Superhero_Mission__c mission = TestDataFactory.createSuperheroMission();
        mission.Guild__c = guild.Id;
        insert mission;

        Mission_Assignment__c assignment = new Mission_Assignment__c();
        assignment.Mission__c = mission.Id;
        assignment.Hero__c = hero.Id;
        insert assignment;
    }

    @isTest
    static void testSendEmails(){
        Mission_Assignment__c assignment = [SELECT Status__c FROM Mission_Assignment__c LIMIT 1];
        assignment.Status__c = 'Completed';

        Test.startTest();
        update assignment;
        Test.stopTest();

        System.assertEquals(2, CompletedMissionDispatch.emailCount, 'Expected 2 email to be sent to Guild Owner and Mission Owner.');

    }
}