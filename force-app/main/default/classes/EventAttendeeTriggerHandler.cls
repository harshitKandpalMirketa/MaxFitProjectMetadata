/**
 * @description       : This class is responsible for sending emails to attendees when they register for an event.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-23-2023
 * @last modified by  : Harshit@mirketa.com
**/

public class EventAttendeeTriggerHandler {

    //Method used in trigger @param eventAttendeeNewRecords - "trigger.new"
    public static void attendeeEmailSend(List<Event_Attendee__c> eventAttendeeNewRecords) {
        
        // Create an empty list of emails to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
       
        // Create sets to hold the event and attendee ids of @param eventAttendeeNewRecords
        Set<Id> eventIds = new Set<Id>();
        Set<Id> attendeeIds = new Set<Id>();

        // Loop through each new event attendee record and add the event and attendee ids to their respective sets
        for (Event_Attendee__c eventAttendeeNewRecord : eventAttendeeNewRecords) {
                eventIds.add(eventAttendeeNewRecord.Event__c);
                attendeeIds.add(eventAttendeeNewRecord.Attendee__c);
        }
        
        // Create a map of events using the event ids obtained earlier
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([
            SELECT Name__c, Starting_Date__c, Location__r.Name, Event_Organizer__r.Name 
            FROM Event__c 
            WHERE Id IN :eventIds
        ]);
        
        // Create a map of attendees using the attendee ids obtained earlier
        Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>([
            SELECT Name, Email__c 
            FROM Attendee__c 
            WHERE Id IN :attendeeIds]);


        // Loop through each new event attendee record again and add an email for each attendee and their respective event
        for (Event_Attendee__c eventAttendeeNewRecord : EventAttendeeNewRecords) {
    
            // Get the event and attendee objects using the maps created earlier
            Event__c event = eventMap.get(eventAttendeeNewRecord.Event__c);
            Attendee__c attendee = attendeeMap.get(eventAttendeeNewRecord.Attendee__c);
            
            // Create a new email message for the attendee
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{attendee.Email__c});
            email.setSubject('Pass for the "' + event.Name__c + '"');
            email.setPlainTextBody('Dear ' + attendee.Name + ',\n\nThank you for registering for "' 
                                   + event.Name__c + '" which will be organized on '
                                   + event.Starting_Date__c.format('dd/mm/yyyy') + ' and will be held in '
                                   + event.Location__r.Name + '. We are excited to have you, see you at the event.\n\nThanks,\n'
                                   + event.Event_Organizer__r.Name);
            //Adding email to the list                       
            emails.add(email);
        }
        
        try {
            //Sending the emails to attendees
            Messaging.sendEmail(emails);
        } catch (Exception e) {
            //Calling the method logError to enter any exception into the Error log object
            ErrorLogger.logError(e.getMessage(), 'Error sending email');
        }
    }
}