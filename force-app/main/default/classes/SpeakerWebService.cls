/**
 * @description       : This class is a web service for creating Speaker records.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-10-2023
 * @last modified by  : Harshit@mirketa.com
**/
@RestResource(urlMapping='/Speakers')
global class SpeakerWebService {
    
    @HttpPost//Post method with parameters of speaker fields.
    global static Id createSpeaker(String name, String email, String phone, String company){
        
        //Creating speaker record
        Speaker__c speaker = new Speaker__c();
        speaker.Name = name;
        speaker.Email__c = email;
        speaker.Phone__c = phone;
        speaker.Company__c = company;

        try{
            //Inserting record and setting status code to 201.
            insert speaker;
            RestContext.response.statusCode = 201;
            return speaker.Id;
        }
        catch(Exception e){

            ErrorLogger.logError(e.getMessage(), 'Speaker web service fail');
            //Xatching error and setting status code to 410.
            RestContext.response.statusCode = 410;
            return null;
        }

    }
}