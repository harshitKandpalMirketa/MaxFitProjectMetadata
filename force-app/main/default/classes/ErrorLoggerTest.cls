/**
 * @description       : This Apex test class is used to test the ErrorLogger class.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-18-2023
 * @last modified by  : Harshit@mirketa.com
**/

@istest
public class ErrorLoggerTest {

    /**
     * This test method tests the logError method of the ErrorLogger class.
     * It checks that the logDetails and processName parameters are correctly
     * saved in a new Error_Log__c record in the database.
     */
    @isTest
    Public static void ErrorLogTest(){
        
        // Define some test data for the logDetails and processName parameters
        string logDetails = 'this is testing details for error log object';
        string processName = 'this is testing name for error log object';
     
        // Start the test execution
        Test.startTest();
        
        // Call the logError method of the ErrorLogger class with the test data
        ErrorLogger.logError(logDetails, processName);
        
        // Stop the test execution
        Test.stopTest();

        // Query the Error_Log__c records from the database to verify that the logError method worked correctly
        List<Error_Log__c> errorLogs = [SELECT Id, Log_Details__c, Process_Name__c FROM Error_Log__c ];
        
        // Assert that only one Error_Log__c record was created, and details are correctly entered
        System.assertEquals(1, errorLogs.size());
        System.assertEquals(logDetails, errorLogs[0].Log_Details__c);
        System.assertEquals(processName, errorLogs[0].Process_Name__c);
    }

    @isTest
    Public static void ErrorLogDetailsTest(){
        
        // Define some test data for the logDetails and processName parameters
        string logDetails = 'this is testing details for error log object';
     
        // Start the test execution
        Test.startTest();
        
        // Call the logError method of the ErrorLogger class with the test data
        ErrorLogger.logErrorDetails(logDetails);
        
        // Stop the test execution
        Test.stopTest();

        // Query the Error_Log__c records from the database to verify that the logError method worked correctly
        List<Error_Log__c> errorLogs = [SELECT Id, Log_Details__c, Process_Name__c FROM Error_Log__c ];
        
        // Assert that only one Error_Log__c record was created, and details are correctly entered
        System.assertEquals(1, errorLogs.size());
        System.assertEquals(logDetails, errorLogs[0].Log_Details__c);
        System.assertEquals('Error', errorLogs[0].Process_Name__c);
    }
}