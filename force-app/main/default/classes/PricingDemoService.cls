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
      commercestorepricing.TransactionalPricingRequest request
    ) {

      System.debug('In commercestorepricing.PricingService processTransactionalPrice, request=' + request);
  
      // Call the default internal pricing implemenation with either original request or modified request
      commercestorepricing.TransactionalPricingResponse response = super.processTransactionalPrice(request);

      commercestorepricing.TxnPricingResponseItemCollection responseCollection = response.getTxnPricingResponseItems();

      commercestorepricing.TxnPricingRequestItemCollection requestCollection = request.getTxnPricingRequestItems();
      for (Integer j = 0; j < requestCollection.size(); j++) {
        Double amount = 0.0;
        commercestorepricing.TransactionalPricingRequestItem requestItem = requestCollection.get(j);
        commercestorepricing.TransactionalPricingResponseItem responseItem = responseCollection.get(j);
        Decimal quantity = requestItem.getQuantity();
        responseItem.setTotalPrice(90 * quantity);
        responseItem.setTotalListPrice(100 * quantity);
        responseItem.setUnitPrice(90);
      }

      // Update the total adjustment and amount at header level accordingly
      response.setTotalAmount(response.getTotalProductAmount());
  
      return response;
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