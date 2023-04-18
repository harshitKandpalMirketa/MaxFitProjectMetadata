/**
 * @description       : Test class for EventBatchPurgeDelete
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-23-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
public class EventBatchPurgeDeleteTest {

    // Define the test method
    @isTest
    public static void testBatchDelete() {

        // Create a list of events to delete
        List<Event__c> eventsToDelete = New List<Event__c>();

        // Use a loop to create 50 events records
        for(Integer i=0;i<50;i++){

            // Create a new event object
            Event__c event = new Event__c();

            event.Starting_Date__c = Date.today().addMonths(-3);
            event.End_Date__c = Date.today().addMonths(-2);
            event.Live__c = true;

            // Add the event to the list of events to delete
            eventsToDelete.add(event);
        }

        // Insert the events into the database
        insert eventsToDelete;

        // Start the test 
        Test.startTest();

        //Created an instance of the batch class
        EventBatchPurgeDelete batch = new EventBatchPurgeDelete();

        // Execute the batch
        Database.executeBatch(batch);
        
        Test.stopTest();

        // Verify that the events were deleted
        List<Event__c> remainingEvents = [SELECT Id FROM Event__c];
        System.assertEquals(0, remainingEvents.size());

        // Verify that the admin received an email
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress FROM EmailMessage WHERE Subject = 'Event Batch delete complete'];
        System.assertEquals(1, sentEmails.size());
        System.assertEquals('harshit.kandpal@mirketa.com', sentEmails[0].ToAddress);
    }
}