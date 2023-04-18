/**
 * @description       : 
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-08-2023
 * @last modified by  : Harshit@mirketa.com
**/
@isTest
global class PriceBookApiCalloutMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest Request) {

        // Create a new HttpResponse object to store the response from the API
        HttpResponse response = new HttpResponse();
        
        // Set the content type of the response to JSON with UTF-8 encoding
        response.setHeader('Content-Type', 'application/json,charset-UTF-8');

        // Set the body of the response to a JSON string containing information about two products
        response.setBody('[{"id":1,"title":"Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops","price":109.95,"description":"Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday","rating":{"rate":3.9,"count":120}},{"id":2,"title":"Mens Casual Premium Slim Fit T-Shirts ","price":22.3,"description":"Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.","rating":{"rate":4.1,"count":259}}]');

         // Set the status code of the response to 200 to indicate success
        response.setStatusCode(200);

        return response;
    }
}