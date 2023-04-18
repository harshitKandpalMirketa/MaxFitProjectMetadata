/**
 * @description       : This class is a web service for fetching event details and event Organiser details.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-12-2023
 * @last modified by  : Harshit@mirketa.com
**/

//
@RestResource(urlMapping='/Events')
global with sharing class EventWebService {

    // Event wrapper class to store data of event in the object
    public class EventWrapper {

        // Initializing variables to store event data
        public string name;        
        public Datetime Date_time; 
        public Integer max_Attendee;
        
        // Creating method to set the values in the EventWrapper object
        public void set(string name, Datetime Date_time,Integer max_Attendee){
            this.name = name;
            this.Date_time = Date_time;
            this.max_Attendee = max_Attendee;
        }
    }

    // Event Organiser wrapper class to store data of event in the object
    public class EventOrganiserWrapper {

        // Initializing variables to store event data
        public string name;        
        public string email;     

        // Creating method to set the values in the EventOrganiserWrapper object
        public void set(string name, string email){
            this.name = name;
            this.email = email;
        }
    }

    // Method to create a map of the object of EventWrapper and EventOrganiserWrapper and return the map
    public static map<String,Object> mapCreator(object eventObject, Object eventOrganiserObject) {

        // Creating and adding objects in the eventDataMap
        Map<String,Object> eventDataMap = new Map<String,Object>();
        eventDataMap.put('event', eventObject);
        eventDataMap.put('event organiser', eventOrganiserObject);

        return eventDataMap;
    }

    @HttpGet // HttpGet method to return the events in the JSON formate
    global static void getEvents() {


        RestContext.response.addHeader('Content-Type', 'application/json,charset-UTF-8');        
        List<Object> eventDataList = new List<Object>();
        
        // Fetching record count from Event__c
        Integer countEventRecords = [SELECT count() FROM Event__c];

        if(countEventRecords < 50000){

            //Running the query to fetch all the events
            List<Event__c> eventQueryList = [SELECT Id,Name__C,Starting_Date__c,People_Attending__c,Event_Organizer__r.Name,Event_Organizer__r.Email__c FROM Event__c];
            
            if(eventQueryList.isEmpty()){
                return;
            }

            // Looping through the events and creating objects for event and event organizer data
            for(Event__c eventQuery : eventQueryList){

                EventOrganiserWrapper eventOrganiserObject = new EventOrganiserWrapper();
                eventOrganiserObject.set(eventQuery.Event_Organizer__r.Name,eventQuery.Event_Organizer__r.Email__c);

                EventWrapper eventObject = new EventWrapper();
                eventObject.set(eventQuery.Name__C,eventQuery.Starting_Date__c,(Integer) eventQuery.People_Attending__c);

                // Creating the map of objects and adding the event and event organizer data to the list 
                eventDataList.add(EventWebService.mapCreator(eventObject, eventOrganiserObject));

            }

            // Setting Responsebody of the restcontext with the list
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(eventDataList));
        }
        else{
            // Logging error if events are more than 50000
            ErrorLogger.logError('Object Contain More than 50000 records', 'Governer limit exception - Web service to get all the events');
        }
    }
}