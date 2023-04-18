/**
 * @description       : Test class for EventAttendeeTriggerHandler
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-23-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
public class EventAttendeeTriggerHandlerTest {
    
    @isTest
    Public static void eventAttendeeTriggerEmailSend(){

        //Create Location record
        Address_Book__c location = new Address_Book__c();
        location.Name = 'Test Location';
        insert location;

        //Create Event record
        Event__c event = new Event__c();
        event.Starting_Date__c = Date.today();
        event.End_Date__c = Date.today().addDays(60);
        event.Location__c = location.id;
        event.Live__c = true;
        event.Max_Seats__c = 100;
        insert event;

        // Create an attendee record
        Attendee__c attendee = new Attendee__c();
        attendee.Name = 'Test Attendee';
        attendee.Email__c = 'testattendee@example.com';
        insert attendee;

        // Create an event attendee record
        Event_Attendee__c eventAttendee = new Event_Attendee__c();
        eventAttendee.Event__c = event.Id;
        eventAttendee.Attendee__c = attendee.Id;

        //Creating List to pass in the method of class EventAttendeeTriggerHandler
        List<Event_Attendee__c> eventAttendeeList = new List<Event_Attendee__c>();
        eventAttendeeList.add(eventAttendee);

        //call the static method to test it
        Test.startTest();
        EventAttendeeTriggerHandler.AttendeeEmailSend(eventAttendeeList);
        Test.stopTest();

         // Verify that the email was sent
         List<EmailMessage> sentEmails = [SELECT Id, ToAddress, subject,TextBody FROM EmailMessage];

         System.assertEquals(1, sentEmails.size());
         System.assertEquals('testattendee@example.com', sentEmails[0].ToAddress);
         System.assertEquals('Pass for the "null"', sentEmails[0].subject);
    }


}