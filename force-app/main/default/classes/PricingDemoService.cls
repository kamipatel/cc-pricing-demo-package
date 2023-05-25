global class PricingDemoService extends commercestorepricing.PricingService {
    
  //Sample for making outbound call https://gist.github.com/kamipatel/c039f5a31ec732080c54494577477016
    global override commercestorepricing.PricingResponse processPrice(
      commercestorepricing.PricingRequest request
    ) {
  
      System.debug('In PricingDemoService.PricingService processPrice, request=' + request);
      

      commercestorepricing.PricingResponse response = new commercestorepricing.PricingResponse('USD');      

      Set<String> products = new Set<String>();
      
      commercestorepricing.PricingRequestItemCollection items = request.getPricingRequestItems();
      for (Integer i = 0; i < items.size(); i++) {
        commercestorepricing.PricingRequestItem item = items.get(i);
        products.add(item.getProductId());
      }
      System.debug('In PricingDemoService.PricingService products=' + products);
            
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
  
      System.debug('PricingDemoService.PricingService response=' + response);
      return response;        
  
    }

    /*
public override commercestorepricing.TransactionalPricingResponse processTransactionalPrice(commercestorepricing.TransactionalPricingRequest request) {
  
  System.debug('In PricingDemoService.PricingService processTransactionalPrice request');

  commercestorepricing.TransactionalPricingResponse res = null;

    System.debug('In PricingDemoService.PricingService processTransactionalPrice before calling super');
    
    commercestorepricing.TransactionalPricingResponse transactionalPricingResponse = super.processTransactionalPrice(request);
    
    System.debug('In PricingDemoService.PricingService processTransactionalPrice after super');

    transactionalPricingResponse.getTxnPricingResponseItems().get(0).setListPrice(15.0);
    transactionalPricingResponse.getTxnPricingResponseItems().get(0).setTotalListPrice(15.0);
    transactionalPricingResponse.getTxnPricingResponseItems().get(0).setTotalLineAmount(30.0);
    transactionalPricingResponse.getTxnPricingResponseItems().get(0).setTotalPrice(30.0);
    transactionalPricingResponse.getTxnPricingResponseItems().get(0).setUnitPrice(30.0);  

    res = transactionalPricingResponse;

    return res;
}
*/


public override commercestorepricing.TransactionalPricingResponse processTransactionalPrice(
      commercestorepricing.TransactionalPricingRequest request
    ) {

      System.debug('In commercestorepricing.PricingService processTransactionalPrice, request=' + request);
      
      String currencyIsoCode = 'USD';                
      Decimal totalListPrice = 0.0; 
      Decimal totalProductAmount = 0.0; 
      Decimal totalAdjustmentAmount = 0.0; 
      Decimal totalAmount= 0.0;          
      String unitPricePriceBookEntryId = '';
      Decimal listPrice = 0.0;
      Decimal unitPrice = 0.0;
      Decimal totalLineAmount = 0.0;
      Decimal unitAdjustmentAmount = 0.0;
      Decimal totalPrice = 0.0;

      commercestorepricing.TransactionalPricingResponse response = new commercestorepricing.TransactionalPricingResponse(totalListPrice,  totalProductAmount,  totalAdjustmentAmount,  totalAmount, currencyIsoCode);

      commercestorepricing.TxnPricingRequestItemCollection requestCollection = request.getTxnPricingRequestItems();
      
      for (Integer j = 0; j < requestCollection.size(); j++) {

        System.debug('In commercestorepricing.PricingService processTransactionalPrice, loop index=' + j);

        Double amount = 0.0;
        commercestorepricing.TransactionalPricingRequestItem requestItem = requestCollection.get(j);

        String lineId = requestItem.getLineId();
        String productId = requestItem.getProductId();
        Decimal quantity = requestItem.getQuantity();

        commercestorepricing.TransactionalPricingResponseItem responseItem = new commercestorepricing.TransactionalPricingResponseItem( lineId,  productId,  unitPricePriceBookEntryId,  listPrice,  unitPrice,  totalListPrice,  totalLineAmount,  totalAdjustmentAmount,  unitAdjustmentAmount,  totalPrice,  quantity,  currencyIsoCode);
        
        responseItem.setTotalPrice(90 * quantity);
        responseItem.setTotalListPrice(90 * quantity);
        responseItem.setUnitPrice(90);

        response.addTxnPricingResponseItem(responseItem);
        System.debug('In commercestorepricing.PricingService completed loop index=' + j);        
      }

      // Update the total adjustment and amount at header level accordingly
      response.setTotalAmount(response.getTotalProductAmount());

      return response;
    }      
  

  /*
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
*/

    /*
    private Map<String, String> getMappedCurrencies() {
      Map<String, String> mappedCurrencies = new Map<String, String>();
      mappedCurrencies.put('USD', 'EUR');
      // Customers can easily provide a mapping for currencies in case they do not sell in some
      // currencies or the prices are to be stored in a different currency. They can also have their
      // custom conversions defined and used.
      return mappedCurrencies;
    }
  */
  
    @TestVisible
    private String appendField(String prefix, String field) {
      // Customers can easily change the string IDs returned by Salesforce Internal Pricing API
      return prefix + field;
    }
  
  }