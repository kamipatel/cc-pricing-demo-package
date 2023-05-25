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

      commercestorepricing.TxnPricingRequestItemCollection requestCollection = request.getTxnPricingRequestItems();
      commercestorepricing.TransactionalPricingResponse response = new commercestorepricing.TransactionalPricingResponse(totalListPrice,  totalProductAmount,  totalAdjustmentAmount,  totalAmount, currencyIsoCode);
      
      for (Integer j = 0; j < requestCollection.size(); j++) {

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
  
    @TestVisible
    private String appendField(String prefix, String field) {
      // Customers can easily change the string IDs returned by Salesforce Internal Pricing API
      return prefix + field;
    }
  
  }