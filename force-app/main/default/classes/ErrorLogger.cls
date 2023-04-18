/**
 * @description       : This is a reusable code to Dynamically enter details in the error log object. 
 * @author            : Harshit@mirketa.com
 * @last modified on  : 03-20-2023
 * @last modified by  : Harshit@mirketa.com
**/
public class ErrorLogger {

    // Define a static method named logError that takes two String parameters: logDetails and processName
    public static void logError( String logDetails, String processName) {

        // Create a new instance of the Error_Log__c object
        Error_Log__c errorLog = new Error_Log__c();

        //Assigning data to the instance
        errorLog.Log_Date_Time__c = Datetime.now();
        errorLog.Log_Details__c = logDetails;
        errorLog.Process_Name__c = processName;
        
        //Inserting the record
        insert errorLog;
    }
}