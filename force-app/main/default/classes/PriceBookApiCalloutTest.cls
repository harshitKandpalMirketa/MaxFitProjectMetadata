/**
 * @description       : This is our test class for the API callout for insertion of products and their prices
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-11-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
public class PriceBookApiCalloutTest {

    @isTest
    static void PriceBookApiTest() {

        // Set up a mock response for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new PriceBookApiCalloutMock());

        Test.startTest();
        // Call the method that makes the HTTP callout and returns a list of PricebookEntry objects
        PriceBookApiCallout.priceBookGetCallout();

        // Get the first PricebookEntry object from the list and use it to query the associated Product2 and Pricebook2 objects
        Pricebook2 priceBook = [SELECT ID,Name FROM Pricebook2 WHERE Name = 'HarshitPricebook'  LIMIT 1];
        List<PricebookEntry> priceEntry = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice  FROM PricebookEntry WHERE Pricebook2Id =: pricebook.id];
        List<Product2> product = [SELECT ID,Name,ProductCode FROM Product2 WHERE Id IN (SELECT Product2Id FROM PricebookEntry WHERE Pricebook2Id = :priceBook.Id)];
        
        // Verify that the response contains two PricebookEntry objects
        System.assertEquals(2, PriceEntry.size());

        // Verify that the unit price of the PricebookEntry matches the expected value
        System.assertEquals(109.95, PriceEntry[0].UnitPrice);

        // Verify that the name of the Pricebook2 object matches the expected value
        System.assertEquals('HarshitPricebook', priceBook.Name);
        
        // Verify that the product code and name of the Product2 object match the expected values
        System.assertEquals('1', product[0].ProductCode);
        System.assertEquals('Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops', product[0].Name);

        Test.stopTest();
    }

    @isTest
    static void PriceBookExistingApiTest() {

        // Set up a mock response for the HTTP callout
        Test.setMock(HttpCalloutMock.class, new PriceBookApiCalloutMock());

        Pricebook2 pricebookEntry = new Pricebook2(Name = 'HarshitPricebook', IsActive = true);
        insert pricebookEntry;

        Product2 productEntry = new Product2(ProductCode = '1', Name = 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops');
        insert productEntry;

        Test.startTest();
        // Call the method that makes the HTTP callout and returns a list of PricebookEntry objects
        PriceBookApiCallout.priceBookGetCallout();

        // Get the first PricebookEntry object from the list and use it to query the associated Product2 and Pricebook2 objects
        List<Pricebook2> priceBook = [SELECT Id,Name FROM Pricebook2 WHERE Name = 'HarshitPricebook'];
        List<PricebookEntry> priceEntry = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice  FROM PricebookEntry WHERE Pricebook2Id =: pricebook[0].id];
        List<Product2> product = [SELECT ID,Name,ProductCode FROM Product2 WHERE Id IN (SELECT Product2Id FROM PricebookEntry WHERE Pricebook2Id = :priceBook[0].Id)];
        
        // Verify that only one pricebook is entered
        System.assertEquals(1, pricebook.size());

        // Verify that the response contains two PricebookEntry objects
        System.assertEquals(1, PriceEntry.size());

        // Verify that the response contain two products only
        System.assertEquals(1, product.size());

        // Verify that the name of the Pricebook2 object matches the expected value
        System.assertEquals('HarshitPricebook', priceBook[0].Name);
        

        Test.stopTest();
    }
}