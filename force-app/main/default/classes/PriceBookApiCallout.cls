/**
 * @description       : This method makes a callout to an external API to retrieve a list of products
 *                      and adds the products and their prices to both the custom pricebook and the standard pricebook.
 * @author            : Harshit@mirketa.com
 * @last modified on  : 04-12-2023
 * @last modified by  : Harshit@mirketa.com
**/
public class PriceBookApiCallout {
    
    //Creating Product Wrapper to store response in objects
    public class ProductWrapper{
        public String id;
        public String title;
        public Decimal price;
        public String description;
        public String category;
        public String image;
        public RatingWrapper rating;
    }
    // Creating wrapper class for the rating field in response
    public class RatingWrapper {
        public Double rate;
        public Integer count;
    } 

    

    public static void priceBookGetCallout() {

        // Create an HTTP instance and initialize the request.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://fakestoreapi.com/products');
        request.setMethod('GET');

        // Send the HTTP request and receive the response.
        HttpResponse response = http.send(request);

        // Initialize variables for storing product, pricebook, and pricebook entry data.
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> standardPriceBookEntries = new List<PricebookEntry>();
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        List<Pricebook2> priceBookList = new List<Pricebook2>();

        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {

            // Deserializes the JSON Response into List of Objects.
            List<ProductWrapper> ProductsObject = (List<ProductWrapper>) JSON.deserializeStrict(response.getBody(), List<ProductWrapper>.class);
            
            // If query is not empty then insert products
            if(!productsObject.isEmpty()){
                
                // Fetching HarshitPricebook if it exist.
                priceBookList = [SELECT id FROM Pricebook2 WHERE Name = 'HarshitPricebook' LIMIT 1];    

                if(priceBookList.isEmpty()){
                    // If pricebook is not created already then create a custom price book record and insert it.
                    Pricebook2 priceBook = new Pricebook2(Name = 'HarshitPricebook', IsActive = true );
                    priceBookList.add(pricebook);
                    insert priceBookList;
                }
    
                // Initialize a variable to store the ID of the standard price book
                Id standardPriceBookId;
                
                // Check if the function is being called from a test class.
                if(Test.isRunningTest()) {
                    // If so, get the ID of the standard price book using a test method.
                    standardPriceBookId = Test.getStandardPricebookId(); 
                    
                } else {
                    // Otherwise, query for the object of the standard price book.
                    Pricebook2 standardPriceBook = [SELECT Id,name FROM Pricebook2 WHERE IsStandard = true AND Name = 'Standard Price Book' LIMIT 1];
                    standardPriceBookId = standardPriceBook.Id;
                }

                // Creating productcode List of response
                List<String> productCodeApiList = new List<String>();
                for(ProductWrapper productObject : ProductsObject) {
                    productCodeApiList.add(productObject.id);
                }
                // Initilizing a product code list to add porduct code of the products
                List<String> productCodeList = new List<String>();
                // Quering all the products
                List<Product2> existingProducts = [SELECT Id, productCode FROM Product2 WHERE ProductCode IN :productCodeApiList ];
                // Checking if query is not empty
                if(!existingProducts.isEmpty()){
                    // Looping through the products and adding it to the productCodeList
                    for(Product2 existingProduct : existingProducts){
                        if(existingProduct.productCode!=null){
                            productCodeList.add(existingProduct.productCode);
                        }
                    }
                }
    
                // Loop through each object in the list of results.
                for(ProductWrapper productObject : ProductsObject){
    
                    // Don't insert the product entry and product if the product already exists
                    if((!productCodeList.isEmpty()) && productCodeList.contains(productObject.id)){
                        continue;
                    }
    
                    //Initializing variable for each object to insert
                    Product2 product = new product2();
                    PricebookEntry standardpriceBookEntry = new PricebookEntry();
                    PricebookEntry priceBookEntry = new PricebookEntry();
                    
                    //Creating product record and adding it to the list
                    product.ProductCode = productObject.id; 
                    product.Name = productObject.title;
                    product.Description = productObject.description;
                    products.add(product);
                    
                    //Creating standard pricebook entry and adding it to the list
                    standardpriceBookEntry.UnitPrice = productObject.price;
                    standardpriceBookEntry.Pricebook2Id = standardPriceBookId;
                    standardpriceBookEntry.IsActive = true;
                    standardPriceBookEntries.add(standardpriceBookEntry);
                    
                    //Creating custom pricebook entry and adding it to the list
                    priceBookEntry.UnitPrice = productObject.price;
                    priceBookEntry.Pricebook2Id = priceBookList[0].id;
                    priceBookEntry.IsActive = true;
                    priceBookEntries.add(priceBookEntry);
    
                }
                insert products;
                
                // Assigns the ID of each product to its corresponding standard and custom price book entries
                Integer count = 0;
                for(product2 product : products){
                    standardPriceBookEntries[count].Product2Id = product.id;
                    priceBookEntries[count].Product2Id = product.id;
                    count++;                
                }
                insert standardPriceBookEntries;
                insert priceBookEntries;
            }
        }
    }
}