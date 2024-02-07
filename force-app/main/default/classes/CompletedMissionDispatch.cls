public inherited sharing class CompletedMissionDispatch {
    final Id EMAIL_TEMPLATE_ID;
    final Id ORG_WIDE_EMAIL_ADDRESS_ID;

    Email_Service__mdt completedMissionEmailServiceMdt;
    
    List<Mission_Assignment__c> completedAssignments { get; set; }
    List<Messaging.SingleEmailMessage> emails { get; set; }
    Map<String, EmailTemplate> emailTemplatesByNames { get; set; }

    @TestVisible
    private static Integer emailCount;

    public CompletedMissionDispatch(Set<Id> completedAssignmentIds) {
        this.completedAssignments = [SELECT Mission__c, Mission__r.OwnerId, Mission__r.Guild__r.OwnerId FROM Mission_Assignment__c WHERE Id IN : completedAssignmentIds];
        this.emails = new List<Messaging.SingleEmailMessage>();

        this.completedMissionEmailServiceMdt = Email_Service__mdt.getInstance('Completed_Mission_Email_Service');
        this.emailTemplatesByNames = SelectorUtils.getEmailTemplatesByDevNames(new Set<String>{
            completedMissionEmailServiceMdt.First_Email_Template__c
        });
        this.EMAIL_TEMPLATE_ID = emailTemplatesByNames.get(completedMissionEmailServiceMdt.First_Email_Template__c).Id;

        this.ORG_WIDE_EMAIL_ADDRESS_ID = SelectorUtils.getOrgWideEmailAddressByAddressField(completedMissionEmailServiceMdt.Org_Wide_Email_Address__c).Id;
    }

    public void sendEmails() {
        for (Mission_Assignment__c assignment : completedAssignments) {
            if (assignment != null && assignment.Mission__c != null) {
                Messaging.SingleEmailMessage emailToMissionOwner = EmailService.createEmail(
                    assignment.Mission__r.OwnerId, 
                    EMAIL_TEMPLATE_ID, 
                    ORG_WIDE_EMAIL_ADDRESS_ID, 
                    true
                );
                emailToMissionOwner.setWhatId(assignment.Mission__c);
                emails.add(emailToMissionOwner);

                Messaging.SingleEmailMessage emailToGuildOwner = EmailService.createEmail(
                    assignment.Mission__r.Guild__r.OwnerId, 
                    EMAIL_TEMPLATE_ID, 
                    ORG_WIDE_EMAIL_ADDRESS_ID, 
                    true
                );
                emailToGuildOwner.setWhatId(assignment.Mission__c);
                emails.add(emailToGuildOwner);
            }
        }

        if (emails != null && !emails.isEmpty()) {
            emailCount = emails.size();
            EmailService.sendEmails(emails);
        }
    }
}