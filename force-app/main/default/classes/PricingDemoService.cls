global class PricingDemoService extends commercestorepricing.PricingService {
    
  //Sample for making outbound call https://gist.github.com/kamipatel/c039f5a31ec732080c54494577477016
    global override commercestorepricing.PricingResponse processPrice(
      commercestorepricing.PricingRequest request
    ) {
  
      System.debug('In PricingDemoService.PricingService processPrice, request=' + request);

      //Get pricebook pricing 
      //super.processPrice(request);
      
      commercestorepricing.PricingResponse response = new commercestorepricing.PricingResponse('USD');
      Set<String> products = new Set<String>();
      
      try{    
              
      commercestorepricing.PricingRequestItemCollection items = request.getPricingRequestItems();
      for (Integer i = 0; i < items.size(); i++) {
        commercestorepricing.PricingRequestItem item = items.get(i);
        products.add(item.getProductId());
      }
      
      Set<String> encodedProductIDs = new Set<String>();
      for (String productID : products) {
        encodedProductIDs.add(EncodingUtil.urlEncode(productID, 'UTF-8'));
      }      
      
      Integer i = 0;
      for(String productId : products) {
            // Print each element in the set
            System.debug(productId);
            commercestorepricing.PricingResponseItem responseItem = new commercestorepricing.PricingResponseItem(
                productId,
                null,
                null,
                100.00,
                90.00
              );
             response.addPricingResponseItem(responseItem);
              i++;
      }                    
  
      }catch(Exception e){
        System.debug('Error processPrice--'+e.getMessage());
      }finally{
          System.debug('Finally processPrice');
      }
  
      return response;        
  
    }
  
    // Override processTransactionalPrice method in order to change behavior of the pricing of multiple
    // products within a transaction
    //
    // Fields that can be overriden are: Header level - currency, error, total list price, total product
    // amount, total adjustment amount and total amount. Item level - line id, product id, unit price,
    // list price, unit pricebook entry id, unit adjustment amount, total line amount, total adjustment
    // amount, total price, and total list price.
    public override commercestorepricing.TransactionalPricingResponse processTransactionalPrice(
      commercestorepricing.TransactionalPricingRequest request2
    ) {
  
      System.debug('In commercestorepricing.PricingService processTransactionalPrice, request=' + request2);
      return super.processTransactionalPrice(request2);
  
    }
  
    private Map<String, String> getMappedCurrencies() {
      Map<String, String> mappedCurrencies = new Map<String, String>();
      mappedCurrencies.put('USD', 'EUR');
      // Customers can easily provide a mapping for currencies in case they do not sell in some
      // currencies or the prices are to be stored in a different currency. They can also have their
      // custom conversions defined and used.
      return mappedCurrencies;
    }
  
  
    @TestVisible
    private String appendField(String prefix, String field) {
      // Customers can easily change the string IDs returned by Salesforce Internal Pricing API
      return prefix + field;
    }
  
  }