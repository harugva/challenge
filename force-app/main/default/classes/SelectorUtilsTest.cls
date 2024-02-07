@isTest
public with sharing class SelectorUtilsTest {

    @isTest
    static void testGetEmailTemplatesByDevNames() {
        Map<String, EmailTemplate> emailTemplatesByNames = SelectorUtils.getEmailTemplatesByDevNames( new Set<String>{ 'Hero_New_Private_Superhero_Mission' });

        Assert.isNotNull(emailTemplatesByNames, 'Expected to return EmailTemplate.');
        Assert.areEqual('Hero_New_Private_Superhero_Mission', emailTemplatesByNames.get('Hero_New_Private_Superhero_Mission').developerName, 'Expected DeveloperName to be "Hero_New_Private_Superhero_Mission".');
    }

    @isTest
    static void testGetEmailTemplatesDevByNamesNegative() {
        Map<String, EmailTemplate> emailTemplatesByNames = SelectorUtils.getEmailTemplatesByDevNames(new Set<String>{ 'Non_Existent_Email_Template' });

        Assert.isNull(emailTemplatesByNames, 'Expected to return null.');
    }

    @isTest
    static void testGetOrgWideEmailAddressByAddressField() {
        OrgWideEmailAddress orgWideEmailAddress = SelectorUtils.getOrgWideEmailAddressByAddressField('tsvorp95@gmail.com'); 

        Assert.isNotNull(orgWideEmailAddress, 'Expected to return OrgWideEmailAddress.');
        Assert.areEqual('Mission Headquarter', orgWideEmailAddress.DisplayName, 'Expected to retrieve OrgWideEmailAddress with such DisplayName.');

    }

    @isTest
    static void testGetOrgWideEmailAddressByAddressFieldNegative() {
        OrgWideEmailAddress orgWideEmailAddress = SelectorUtils.getOrgWideEmailAddressByAddressField('non_existent@test.test'); 

        Assert.isNull(orgWideEmailAddress, 'Expected to return null.');
    }

    @isTest
    static void testGetProfileByNamePositive() {
        Profile standardProfile = SelectorUtils.getProfileByName('Standard user');

        Assert.isNotNull(standardProfile , 'Expected not to return null.');
        Assert.areEqual('Standard User', standardProfile.Name, 'Expected profile name to be Standard user.');
    }

    @isTest
    static void testGetProfileByNameNegative() {
        Profile standardProfile = SelectorUtils.getProfileByName('Non Existent');

        Assert.isNull(standardProfile, 'Expected to return null.');
    }
}