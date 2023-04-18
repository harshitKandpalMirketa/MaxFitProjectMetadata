/**
 * @description       : This is a controller class for the Attendee Registartion page
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-04-2023
 * @last modified by  : Harshit@mirketa.com
**/
public with sharing class AttendeeRegistartionPageController {

    // Properties for Event Attendee, Attendee, Location and a public eventId to store if is passed through URL
    public Event_Attendee__c eveAttendee{get; set;}
    public Attendee__c attendee {get; set;}
    public Address_Book__c locAttendee {get; set;}
    public Id eventId;


    public AttendeeRegistartionPageController() {
    
        //Get the id from the Apex Page.
        eventId = ApexPages.currentPage().getParameters().get('id');
    
        eveAttendee = new Event_Attendee__c();
        attendee = new Attendee__c();
        locAttendee = new Address_Book__c();
        
        //If id was passed the assign it to the event variable
        if(eventId != null){
            eveAttendee.Event__c = eventId;
        }
    }

    // The saveRecord() method inserts the location records, assigns their IDs to the event and organizer, and inserts them as well
    public void saveRecord(){

        //Creating a checkpoint before inserting
        Savepoint sp = Database.setSavepoint();

        try{
        
            insert locAttendee;
            
            //Assigning location in Attendee object
            attendee.Location__c = locAttendee.Id;
            insert attendee;
    
            //Assigning Attendee in Event Attendee object
            eveAttendee.Attendee__c = Attendee.Id;
            insert eveAttendee;
    
            eveAttendee = new Event_Attendee__c();
            attendee = new Attendee__c();
            locAttendee = new Address_Book__c();

        }
        catch(Exception e){
            // If an exception occurs, the method logs the error and rolls back the transaction using a savepoint
            ErrorLogger.logError(e.getMessage(),'Error inserting through Visualforce');
            Database.RollBack(sp);
        }
    
    }
}