public with sharing class SelectorUtils {
    public static Map<String, EmailTemplate> getEmailTemplatesByDevNames(Set<String> developerNames) {
        Map<String, EmailTemplate> emailTemplatesByDeveloperNames = new Map<String, EmailTemplate>();
        List<EmailTemplate> emailTemplates = [
            SELECT Id, DeveloperName
            FROM EmailTemplate 
            WHERE DeveloperName IN : developerNames
        ];

        if (emailTemplates != null && !emailTemplates.isEmpty()) {
            for (EmailTemplate template : emailTemplates) {
                emailTemplatesByDeveloperNames.put(template.DeveloperName, template);
            }
        } else {
            return null;
        }
        return emailTemplatesByDeveloperNames;
    }

    public static OrgWideEmailAddress getOrgWideEmailAddressByAddressField(String emailAddress) {
        List<OrgWideEmailAddress> orgWideEmailAddresses = [
            SELECT Id, DisplayName, Address 
            FROM OrgWideEmailAddress
            WHERE Address = : emailAddress
        ];
        return !orgWideEmailAddresses.isEmpty() ? orgWideEmailAddresses[0] : null;
    }

    public static Profile getProfileByName(String name) {
        List<Profile> profiles = [
            SELECT Id, Name 
            FROM Profile 
            WHERE Name = : name
        ];
        return !profiles.isEmpty() ? profiles[0] : null;
    }
}