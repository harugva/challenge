public inherited sharing class EmailService {
    public static Messaging.SingleEmailMessage createEmail(Id targetId, Id templateId, Id orgWideEmailAddressId, Boolean treatTargetObjectAsRecipient) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setTargetObjectId(targetId);
        email.setTemplateId(templateId);
        email.setOrgWideEmailAddressId(orgWideEmailAddressId);
        email.setTreatTargetObjectAsRecipient(treatTargetObjectAsRecipient);
        email.setSaveAsActivity(false);
 
        return email;
    }

    public static void sendEmails(List<Messaging.SingleEmailMessage> emails) {
        try {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emails, false);
            for (Messaging.SendEmailResult result : results) {
                if (!result.isSuccess()) {
                    System.debug('SendEmailResult errors::: ' + result.getErrors());
                }
            }
        } catch (Exception e) {
            System.debug('Error message: ' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }
}