/**
 * @description       : This is a controller class for the Event Detail page
 * @author            : Harshit@mirketa.com 
 * @last modified on  : 04-04-2023
 * @last modified by  : Harshit@mirketa.com
**/
public with sharing class EventDetailController {

    // Properties for Event Speaker, Event
    public Event__c event { get; set;}
    public List<Event_Speaker__c> eveSpeaker { get; set;}

    public EventDetailController(){

        //Get the id from the Apex Page.
        Id recordId = ApexPages.currentPage().getParameters().get('id');

        //Getting the records of the event and speaker assigned to the event
        this.event = [SELECT Id,Name__c,Starting_Date__c,Location__r.State__c,Location__r.Street__c,Location__r.Postal_Code__c,Location__r.Country__c,Location__r.City__c,Event_Organizer__r.Name FROM Event__c WHERE Id =: recordId];
        this.eveSpeaker = [SELECT Id,Speaker__r.Name,Speaker__r.Profile_Url__c,Speaker__r.About_Me__c FROM Event_Speaker__c WHERE Event__c =:recordId  ];
    }
}