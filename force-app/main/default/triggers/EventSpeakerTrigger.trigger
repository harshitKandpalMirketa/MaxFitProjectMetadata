/**
 * @description       : This is a trigger for the Event Speaker custom object. It calls a static method that checks for conflicts in speaker booking across events.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-23-2023
 * @last modified by  : Harshit@mirketa.com
**/

trigger EventSpeakerTrigger on Event_Speaker__c (before insert) {

    if(trigger.isBefore){
        if(trigger.isInsert){
            //Calling the method SpeakerBookingCheck from the class EventSpeakerTriggerHandler by passing trigger.new as parameter
            EventSpeakerTriggerHandler.speakerBookingCheck(trigger.new);
        }
    }

}