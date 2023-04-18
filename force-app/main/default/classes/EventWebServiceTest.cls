/**
 * @description       : This class is a test to the web service for fetching event details and event Organiser details.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-11-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
public class EventWebServiceTest {

    @isTest
    static void getEventsTest(){

        //Creating Entries for event Organiser and event.(*Did not made records in test setup because we want an empty org for another test method)

        //Event Organiser
        Event_Organizer__c eveOrganiser = new Event_Organizer__c();
        eveOrganiser.Name = 'Harshit kandpal';
        eveOrganiser.Email__c ='Harshitk0011@gmail.com';
        insert eveOrganiser;

        //Event Record
        Event__c event = new Event__c();
        event.Name__C = 'Test Event';
        event.Starting_Date__c = Date.today();
        event.Max_Seats__c = 50;
        event.Event_Organizer__c = eveOrganiser.id;
        insert event;

        Test.startTest();

        RestContext.response = new RestResponse();

        //Calling the method
        EventWebService.getEvents();

        List<Object> results = (List<Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        map<string, object> ResultDataMap = (map<string, object>) results[0];

        Map<string,Object> eventDataMap = (Map<string,Object>) ResultDataMap.get('event');

        system.assertEquals('Test Event', string.valueOf(eventDataMap.get('name')));

        Test.stopTest();
    }

    @isTest
    static void getNoEventTest(){

        Test.startTest();

        RestContext.response = new RestResponse();
        
        //Calling the method
        EventWebService.getEvents();

        system.assertEquals(null,RestContext.response.responseBody);

        Test.stopTest();
        
    }
}