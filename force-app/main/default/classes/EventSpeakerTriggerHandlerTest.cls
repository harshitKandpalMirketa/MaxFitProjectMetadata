/**
 * @description       : Test class for EventSpeakerTriggerHandler
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-28-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
public class EventSpeakerTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        //Create location record
        Address_Book__c location = new Address_Book__c();
        location.Name = 'Test Location';
        insert location;

        //Create event record
        Event__c event1 = new Event__c();
        event1.Starting_Date__c = Date.today();
        event1.End_Date__c = Date.today().addDays(10);
        event1.Location__c = location.id;
        event1.Live__c = true;
        event1.Max_Seats__c = 100;
        insert event1;

        //Create non colidingc event record
        Event__c event2 = new Event__c();
        event2.Starting_Date__c = Date.today().addDays(40);
        event2.End_Date__c = Date.today().addDays(50);
        event2.Location__c = location.id;
        event2.Live__c = true;
        event2.Max_Seats__c = 100;
        insert event2;

        //Create Event that will collide with event 1 and has its starting date before event1 start date(BEFORE-End) record
        Event__c eventColidingBefore1 = new Event__c();
        eventColidingBefore1.Starting_Date__c = Date.today().addDays(-5);
        eventColidingBefore1.End_Date__c = Date.today().addDays(5);
        eventColidingBefore1.Location__c = location.id;
        eventColidingBefore1.Live__c = true;
        eventColidingBefore1.Max_Seats__c = 100;
        insert eventColidingBefore1;

        //Create Event that will collide with event 1 and has its starting date after event1 start date(AFTER-Start) record
        Event__c eventColidingAfter1 = new Event__c();
        eventColidingAfter1.Starting_Date__c = Date.today().addDays(5);
        eventColidingAfter1.End_Date__c = Date.today().addDays(15);
        eventColidingAfter1.Location__c = location.id;
        eventColidingAfter1.Live__c = true;
        eventColidingAfter1.Max_Seats__c = 100;
        insert eventColidingAfter1;

        //Create Event that will collide with event 1 and has its starting date after event1 start date(AFTER-Start) record
        Event__c eventColidingOver1 = new Event__c();
        eventColidingOver1.Starting_Date__c = Date.today().addDays(-10);
        eventColidingOver1.End_Date__c = Date.today().addDays(20);
        eventColidingOver1.Location__c = location.id;
        eventColidingOver1.Live__c = true;
        eventColidingOver1.Max_Seats__c = 100;
        insert eventColidingOver1;


        //Create Speaker1 record
        Speaker__c speaker1 = new Speaker__c();
        speaker1.Name = 'Test speaker1';
        speaker1.Email__c = 'TestSpeaker1@gmail.com';
        insert speaker1;

        //Create Event1 - speaker1 record
        Event_Speaker__c eventSpeaker1 = new Event_Speaker__c();
        eventSpeaker1.Name = 'Test Record';
        eventSpeaker1.Event__c = event1.id;
        eventSpeaker1.Speaker__c = Speaker1.id;
        insert eventSpeaker1;

                //Create Event2 - speaker1 non coflicting record
                Event_Speaker__c eventSpeaker2 = new Event_Speaker__c();
                eventSpeaker2.Name = 'Test Record';
                eventSpeaker2.Event__c = event2.id;
                eventSpeaker2.Speaker__c = Speaker1.id;
                insert eventSpeaker2;

    }

    //Test method for event that conflict with old event and has it's exact date with old event
    @isTest
    Public static void conflictEventTimeExact(){
        //Fetching Old event1
        List<Event__c> event = [SELECT Id FROM Event__c WHERE End_Date__c = NEXT_N_DAYS:10 ];
        Event__c event1 = event[0];

        //Fetching Speaker1 record
        List<Speaker__c> speaker = [SELECT Id,Name,Email__c FROM Speaker__c WHERE Name = 'Test speaker1'];
        Speaker__c speaker1 = speaker[0];

        //Create conflicting Event speaker record with same records in the object.
        Event_Speaker__c eventSpeaker2 = new Event_Speaker__c();
        eventSpeaker2.Name = 'Test Record';
        eventSpeaker2.Event__c = event1.Id;
        eventSpeaker2.Speaker__c = speaker1.Id;

        List<Event_Speaker__c> toPass = New List<Event_Speaker__c>();
        toPass.add(eventSpeaker2);

        Test.startTest();
        try {
            EventSpeakerTriggerHandler.speakerBookingCheck(toPass); 
        } catch (DmlException e) {

            //Checking if the error is same as given in the code.
            System.assertEquals('Already assigned to Event', e.getMessage());
        }
               
        Test.stopTest();
        
    }

    //Test method for event that conflict with old event and has it's starting date between old event
    @isTest
    Public static void conflictEventTimeAfter(){
        //Fetching Old event3
        List<Event__c> event = [SELECT Id FROM Event__c WHERE End_Date__c = NEXT_N_DAYS:15 ];
        Event__c event3 = event[0];

        //Fetchting Speaker1
        List<Speaker__c> speaker = [SELECT Id,Name,Email__c FROM Speaker__c WHERE Name = 'Test speaker1'];
        Speaker__c speaker1 = speaker[0];

        //Create conflicting Event speaker record with event that conflict with event in the object
        Event_Speaker__c eventSpeaker2 = new Event_Speaker__c();
        eventSpeaker2.Name = 'Test Record';
        eventSpeaker2.Event__c = event3.Id;
        eventSpeaker2.Speaker__c = speaker1.Id;

        List<Event_Speaker__c> toPass = New List<Event_Speaker__c>();
        toPass.add(eventSpeaker2);

        Test.startTest();
        try {
            EventSpeakerTriggerHandler.speakerBookingCheck(toPass); 
        } catch (DmlException e) {
            //Checking if the error is same as given in the code.
            System.assertEquals('Already assigned to Event', e.getMessage());
        }
               
        Test.stopTest();
        
    }

    //Test method for event that conflict with old event and has it's end date between old event
    @isTest
    Public static void conflictEventTimeBefore(){
        //Fetching event2
        List<Event__c> event = [SELECT Id FROM Event__c WHERE End_Date__c = NEXT_N_DAYS:5 ];
        Event__c event2 = event[0];

        //Fetchting Speaker1
        List<Speaker__c> speaker = [SELECT Id,Name,Email__c FROM Speaker__c WHERE Name = 'Test speaker1'];
        Speaker__c speaker1 = speaker[0];

        //Create conflicting Event speaker record with event that conflict with event in the object
        Event_Speaker__c eventSpeaker2 = new Event_Speaker__c();
        eventSpeaker2.Name = 'Test Record';
        eventSpeaker2.Event__c = event2.Id;
        eventSpeaker2.Speaker__c = speaker1.Id;

        List<Event_Speaker__c> toPass = New List<Event_Speaker__c>();
        toPass.add(eventSpeaker2);

        Test.startTest();
        try {
            EventSpeakerTriggerHandler.speakerBookingCheck(toPass); 
        } catch (DmlException e) {
            //Checking if the error is same as given in the code.
            System.assertEquals('Already assigned to Event', e.getMessage());
        }
               
        Test.stopTest();
        
    }

    @isTest
    Public static void conflictEventTimeOver(){
        //Fetching event2
        List<Event__c> event = [SELECT Id FROM Event__c WHERE End_Date__c = NEXT_N_DAYS:20 ];
        Event__c event2 = event[0];

        //Fetchting Speaker1
        List<Speaker__c> speaker = [SELECT Id,Name,Email__c FROM Speaker__c WHERE Name = 'Test speaker1'];
        Speaker__c speaker1 = speaker[0];

        //Create conflicting Event speaker record with event that conflict with event in the object
        Event_Speaker__c eventSpeaker2 = new Event_Speaker__c();
        eventSpeaker2.Name = 'Test Record';
        eventSpeaker2.Event__c = event2.Id;
        eventSpeaker2.Speaker__c = speaker1.Id;

        List<Event_Speaker__c> toPass = New List<Event_Speaker__c>();
        toPass.add(eventSpeaker2);

        Test.startTest();
        try {
            EventSpeakerTriggerHandler.speakerBookingCheck(toPass); 
        } catch (DmlException e) {
            //Checking if the error is same as given in the code.
            System.assertEquals('Already assigned to Event', e.getMessage());
        }
               
        Test.stopTest();
        
    }
}