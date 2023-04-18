/**
 * @description       : This is a trigger for the Event SAttendee custom object. It calls a static method that is responsible for sending emails to attendees when they register for an event.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-23-2023
 * @last modified by  : Harshit@mirketa.com
**/

trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        EventAttendeeTriggerHandler.attendeeEmailSend(trigger.new);
    }

}