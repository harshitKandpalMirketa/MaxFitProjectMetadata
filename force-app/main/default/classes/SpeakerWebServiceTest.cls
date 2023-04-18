/**
 * @description       : 
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-05-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
public with sharing class SpeakerWebServiceTest {

    @isTest
    static void createSpeakerTest(){
        Test.startTest();
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();

        Id speakerId1 = SpeakerWebService.createSpeaker('Harshit1','Harshitk0011@gmail.com','9205780155','Mirketa');

        Speaker__c speaker1 = [SELECT ID,Name FROM Speaker__c WHERE id =:speakerId1];

        System.assert(speakerId1 != null);
        System.assertEquals('Harshit1', speaker1.Name);
        System.assertEquals(201, RestContext.response.statusCode);

        Test.stopTest();
    }

    @isTest
    static void createDuplicateSpeakerTest(){

        Test.startTest();
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();

        Id speakerId1 = SpeakerWebService.createSpeaker('Harshit1','Harshitk0011@gmail.com','9205780155','Mirketa');
        Id speakerId2 = SpeakerWebService.createSpeaker('Harshit1','Harshitk0011@gmail.com','9205780155','Mirketa');

        System.assert(speakerId2 == null);
        System.assertEquals(410, RestContext.response.statusCode);
        
        Test.stopTest();
    }

}