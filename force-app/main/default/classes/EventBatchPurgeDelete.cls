/**
 * @description       : This is a batch class responsible for deleting event records that are 2 months old and are not live
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-23-2023
 * @last modified by  : Harshit@mirketa.com
**/

public class EventBatchPurgeDelete implements Database.Batchable <SObject> {

    // Start method to retrieve the Ids of events that are 2 months old and not live
    public database.QueryLocator start(Database.BatchableContext bc){

        //Query for Fetching Id of events which are 2 months old and are not live
        String query = 'SELECT Id FROM Event__c WHERE End_Date__c <= LAST_N_MONTHS:2 AND Live__c = true';
        return Database.getQueryLocator(query);
    }
    
    // Execute method to delete the retrieved event records
    public void execute(Database.BatchableContext bc, List<Event__c> eventIds){
        //Deleting the records
        delete eventIds;
    }
    
    // Finish method to send a confirmation email after batch processing completes
    public void finish(Database.BatchableContext bc){


        // Create a list to store the confirmation emails
        list<Messaging.SingleEmailMessage> confirmationEmails = New List<Messaging.SingleEmailMessage>();
        

        //Feteching Emails from Users with System admin profile
        List<User> sysAdminEmails = [SELECT id, Email FROM User WHERE ProfileId IN (SELECT Id FROM Profile WHERE Name = 'System Administrator')];
        
        // Loop through the System Administrators and create a confirmation email for each
        For( User sysAdmin : sysAdminEmails){

            //Creating instance for mail
            Messaging.SingleEmailMessage confirmationEmail = New Messaging.SingleEmailMessage();       
    
            //Creating and adding the email to confirmationEmails
            confirmationEmail.setToAddresses(new String[]{sysAdmin.Email});
            confirmationEmail.setSubject('Event Batch delete complete');
            confirmationEmail.setPlainTextBody('Delete of records using batch apex is completed');

            //Ading mail to the List of mail
            confirmationEmails.add(confirmationEmail);
        }

        //Sending Email
        Messaging.sendEmail(confirmationEmails);
        
    }
}