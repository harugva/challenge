public with sharing class HeroicDispatch {
    final Id EMAIL_TEMPLATE_ID_IF_PRIVATE_MISSION;
    final Id EMAIL_TEMPLATE_ID_IF_PUBLIC_MISSION;
    final Id ORG_WIDE_EMAIL_ADDRESS_ID;

    Email_Service__mdt heroEmailServiceMdt;
    
    List<Hero__c> heroes { get; set; }
    List<Superhero_Mission__c> superheroMissions { get; set; }
    List<Messaging.SingleEmailMessage> emails { get; set; }
    Map<String, EmailTemplate> emailTemplatesByNames { get; set; }
    Map<Id, User> portalUsersByContactIds { get; set; }

    @TestVisible
    private static Integer emailCount;

    public HeroicDispatch(List<Hero__c> heroes, List<Superhero_Mission__c> superheroMissions) {
        this.heroes = heroes;
        this.superheroMissions = superheroMissions;
        this.emails = new List<Messaging.SingleEmailMessage>();
        this.portalUsersByContactIds = getPortalUsersByContactId();

        this.heroEmailServiceMdt = Email_Service__mdt.getInstance('Hero_Email_Service');
        this.emailTemplatesByNames = SelectorUtils.getEmailTemplatesByDevNames(new Set<String>{
            heroEmailServiceMdt.First_Email_Template__c,
            heroEmailServiceMdt.Second_Email_Template__c
        });
        this.EMAIL_TEMPLATE_ID_IF_PRIVATE_MISSION = emailTemplatesByNames.get(heroEmailServiceMdt.First_Email_Template__c).Id;
        this.EMAIL_TEMPLATE_ID_IF_PUBLIC_MISSION = emailTemplatesByNames.get(heroEmailServiceMdt.Second_Email_Template__c).Id;

        this.ORG_WIDE_EMAIL_ADDRESS_ID = SelectorUtils.getOrgWideEmailAddressByAddressField(heroEmailServiceMdt.Org_Wide_Email_Address__c).Id;
    }

    public void sendEmailsWhenPublicMission() {
        for (User portalUser : portalUsersByContactIds.values()) {
            for (Superhero_Mission__c mission : superheroMissions) {
                Messaging.SingleEmailMessage email = EmailService.createEmail(
                    portalUser.Id, 
                    EMAIL_TEMPLATE_ID_IF_PUBLIC_MISSION, 
                    ORG_WIDE_EMAIL_ADDRESS_ID, 
                    true
                );
                email.setWhatId(mission.Id);
                emails.add(email);
            }
        }

        sendEmails();
    }

    public void sendEmailsWhenPrivateMission() {
        for (Hero__c hero : heroes) {
            for (Superhero_Mission__c mission : superheroMissions) {
                User portalUser = portalUsersByContactIds.get(hero.Contact__c);
                if (hero.Guild__c == mission.Guild__c && portalUser != null) {
                    Messaging.SingleEmailMessage email = EmailService.createEmail(
                        portalUser.Id, 
                        EMAIL_TEMPLATE_ID_IF_PRIVATE_MISSION, 
                        ORG_WIDE_EMAIL_ADDRESS_ID, 
                        true
                    );
                    email.setWhatId(mission.Id);
                    emails.add(email);
                }
            }
        }

        sendEmails();
    }

    private Map<Id, User> getPortalUsersByContactId() {
        Map<Id, User> portalUsersByContactIds = new Map<Id, User>();

        Set<Id> heroContactsIds = Utils.getRelatedIds(heroes, 'Contact__c');
        List<User> portalUsers = [SELECT Id, ContactId FROM User WHERE ContactId IN : heroContactsIds];

        for (User portalUser : portalUsers) {
            portalUsersByContactIds.put(portalUser.ContactId, portalUser);
        }

        return portalUsersByContactIds;
    }

    private void sendEmails() {
        if (emails != null && !emails.isEmpty()) {
            emailCount = emails.size();
            EmailService.sendEmails(emails);
        }
    }
}