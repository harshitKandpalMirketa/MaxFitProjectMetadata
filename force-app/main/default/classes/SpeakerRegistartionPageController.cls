/**
 * @description       : This is a controller class for the Speaker Registartion page
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-04-2023
 * @last modified by  : Harshit@mirketa.com
**/
public with sharing class SpeakerRegistartionPageController {

    // Properties for Event Speaker, Speaker variables and a public eventId to store if is passed through URL
    public Event_Speaker__c eveSpeaker {get; set;}
    public Speaker__c speaker {get; set;}
    public Id eventId;

    // Constructor initializes the properties to new instances of their respective sObjects
    public SpeakerRegistartionPageController() {
        //Get the id from the Apex Page.
        eventId = ApexPages.currentPage().getParameters().get('id');
        eveSpeaker = new Event_Speaker__c();
        speaker = new Speaker__c();

        //If id was passed the assign it to the event variable
        if(eventId != null){
            eveSpeaker.Event__c = eventId;
        }
    }

    // The saveRecord() method inserts the location records, assigns their IDs to the event and organizer, and inserts them as well
    public void saveRecord(){
        Savepoint sp = Database.setSavepoint();

        try{

            insert speaker;

            //Assigning Speaker in Event Speaker object
            eveSpeaker.Speaker__c = speaker.id;
            insert eveSpeaker;
    
            eveSpeaker = new Event_Speaker__c();
            speaker = new Speaker__c();

        }
        catch(Exception e){
             // If an exception occurs, the method logs the error and rolls back the transaction using a savepoint
            ErrorLogger.logError(e.getMessage(),'Error inserting through Visualforce');
            Database.RollBack(sp);
        }
    }
}