/**
 * @description       : This is a controller class for the Event registration page
 * @author            : Harshit@mirketa.com 
 * @last modified on  : 04-04-2023
 * @last modified by  : Harshit@mirketa.com
**/
public with sharing class EventRegistrationController {

    // Properties for Event Organizer, Event, Location
    public  Event_Organizer__c eventOrg {get; set;}
    public Event__c eve {get; set;}
    public Address_Book__c locEvent {get; set;}
    public Address_Book__c locOrganiser {get; set;}

    // Constructor initializes the properties to new instances of their respective sObjects
    public EventRegistrationController() {

        eventOrg = new Event_Organizer__c();
        eve = new Event__c();
        locEvent = new Address_Book__c();
        locOrganiser = new Address_Book__c();

    }

    // The saveRecord() method inserts the location records, assigns their IDs to the event and organizer, and inserts them as well
    public void saveRecord(){

        //Creating a checkpoint before inserting
        Savepoint sp = Database.setSavepoint();

        try{
            
            List<Address_Book__c> location = new List<Address_Book__c>();
            location.add(locOrganiser);   
    
            //Will not add the location of the event type is virtual
            if(eve.Event_Type__c != 'Virtual'){
                location.add(locEvent);        
            }
            
            insert location;
            
            //Assigning Event organiser location in Event organiser object
            eventOrg.Address_Book__c = locOrganiser.id;
                
            insert eventOrg;
            
            //Assigning Event organiser and location in event object
            eve.Location__c = locEvent.id;
            eve.Event_Organizer__C = eventOrg.id;
            insert eve;
            
            
            eve = new Event__c();
            eventOrg = new  Event_Organizer__c();
            locEvent = new Address_Book__c();
            locOrganiser = new Address_Book__c();
        }
        catch(Exception e){

            // If an exception occurs, the method logs the error and rolls back the transaction using a savepoint
            ErrorLogger.logError(e.getMessage(),'Error inserting through Visualforce');            
            Database.RollBack(sp);
        }
    }
}