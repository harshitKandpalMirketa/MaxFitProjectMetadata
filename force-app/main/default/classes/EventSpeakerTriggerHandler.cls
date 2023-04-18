/**
 * @description       : This is a trigger handler class for the Event Speaker custom object. It has a static method that checks for conflicts in speaker booking across events.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-24-2023
 * @last modified by  : Harshit@mirketa.com
**/

public class EventSpeakerTriggerHandler {
    //Method used in trigger @param eventSpeakerNewRecords - "trigger.new"
    public static void speakerBookingCheck(List<Event_Speaker__c> newEventSpeakerRecords) {
      
        // Create sets to store the IDs of new speakers and events
        Set<Id> newSpeakerIds = new Set<Id>();
        Set<Id> newEventIds = new Set<Id>();

        // Iterate over the newEventSpeakerRecords list and add the speaker and event IDs to the corresponding sets
        for(Event_Speaker__c newEventSpeakerRecord : newEventSpeakerRecords){
            newSpeakerIds.add(newEventSpeakerRecord.Speaker__c);
            newEventIds.add(newEventSpeakerRecord.Event__c);
        } 
    
        // Create a map to store the Trigger event records based on their IDs
        Map<Id,Event__c> newEventMap = new Map<Id,Event__c>([SELECT Id,Starting_Date__c,End_Date__c FROM Event__c WHERE Id IN :newEventIds]);

        // Query the Event Speaker records based on the speaker IDs
        List<Event_Speaker__c> eventSpeakers = [SELECT Id, Event__c,Event__r.Name,Event__r.Starting_Date__c,Event__r.End_Date__c, Speaker__c FROM  Event_Speaker__c WHERE Speaker__c IN :newSpeakerIds];

        //Return early if no speaker was found in the event speaker object which can conflict with the inserted or updated records
        if(eventSpeakers.isEmpty()){
            return;
        }

        //This map will store the records of eventSpeaker object in a list with a key of their specific speaker so that we can call it inside the code.
        Map<Id,List<Event_Speaker__c>> speakerEventsMap = new Map<Id,List<Event_Speaker__c>>();

        //Entering the key and object list in the map.
        for(Event_Speaker__c eventSpeaker : eventSpeakers){
            if(speakerEventsMap.containsKey(eventSpeaker.speaker__c)){
                //Entering object in the list if the key is already present
                speakerEventsMap.get(eventSpeaker.speaker__c).add(eventSpeaker);
            }
            else{
                //Entering object in the list with the new speaker key.
                speakerEventsMap.put(eventSpeaker.speaker__c,new List<Event_Speaker__c>{eventSpeaker});
            }
        }

        // Iterate over the newEventSpeakerRecords(trigger.new) list again to check for conflicts
        for(Event_Speaker__c newEventSpeakerRecord : newEventSpeakerRecords){

            // Get the data of inserted/updated event record from the newEventMap
            Event__c newEventTime =  newEventMap.get(newEventSpeakerRecord.Event__c);
  
            //Getting the list of records related to that speaker to check for conflict
            List<Event_Speaker__c> speakerEvents = speakerEventsMap.get(newEventSpeakerRecord.Speaker__c);
  
            // Iterate over the eventSpeakers list to compare with old events
            for(Event_Speaker__c eventSpeaker : speakerEvents){
  
                // Check for time conflicts between the Events already assigned to speaker with the new assigned events
                if  ( ((eventSpeaker.Event__r.Starting_Date__c <= newEventTime.Starting_Date__c) && (eventSpeaker.Event__r.End_Date__c >=newEventTime.Starting_Date__c) )||
                      ((eventSpeaker.Event__r.Starting_Date__c <= newEventTime.End_Date__c )&&(eventSpeaker.Event__r.End_Date__c >=newEventTime.End_Date__c)) ||
                      ((eventSpeaker.Event__r.Starting_Date__c >= newEventTime.Starting_Date__c )&&(eventSpeaker.Event__r.End_Date__c <=newEventTime.End_Date__c))){
    
                    //Throw error if conflict was found
                    newEventSpeakerRecord.Speaker__c.addError('Already assigned to Event');
                    break;
                  } 
            }
        }

    }
}