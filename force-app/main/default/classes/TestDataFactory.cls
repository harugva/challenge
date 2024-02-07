public with sharing class TestDataFactory {

    public static Contact createContact() {
        Contact contact = new Contact();
        contact.LastName = 'Beer';
        contact.FirstName = 'John';
        return contact;
    }

    public static Guild__c createGuild() {
        Guild__c guild = new Guild__c();
        guild.Name = 'Safe space';
        return guild;
    }

    public static Hero__c createHero() {
        Hero__c hero = new Hero__c();
        hero.Name = 'spider';
        hero.Rank__c = 'B';
        return hero;
    }

    public static Superhero_Mission__c createSuperheroMission() {
        Superhero_Mission__c mission = new Superhero_Mission__c();
        mission.Subject__c = 'Try to wake up at 6 on Sunday.';
        mission.Complexity_Rank__c = 'B';
        mission.Is_Public__c = true;
        mission.Details__c = 'Details are hidden.';
        mission.Reward__c = 100;
        mission.Deadline__c = Date.today();
        return mission;
    }

    public static User createPartnerUser() {
        User partnerUser = new User();
        partnerUser.FirstName = 'John';
        partnerUser.LastName = 'Beer';
        partnerUser.Alias = 'JBeer';
        partnerUser.email = 'john.beer@gmail.com.test';
        partnerUser.UserName = 'john.beer@gmail.com.test';
        partnerUser.PortalRole = 'Manager';
        partnerUser.Profileid = SelectorUtils.getProfileByName('Hero World User').Id;
        partnerUser.LanguageLocaleKey = 'en_US';
        partnerUser.LocaleSidKey = 'en_US';
        partnerUser.EmailEncodingKey = 'ISO-8859-1';
        partnerUser.TimeZoneSidKey = 'America/New_York';
        return partnerUser;
    }
}