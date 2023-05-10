global class PricingDemoService extends commercestorepricing.PricingService {

    public void log(String brief, String detail){    
        System.debug('In PricingDemoService.PricingService brief=' + brief + ', details,' + detail);    
    }
    
      public override commercestorepricing.PricingResponse processPrice(
        commercestorepricing.PricingRequest request
      ) {
    
        System.debug('In PricingDemoService.PricingService processPrice, request=' + request);

        super.processPrice(request);
        
        commercestorepricing.PricingResponse response = new commercestorepricing.PricingResponse('USD');
        Set<String> products = new Set<String>();
        
        try{    
        
        log('processPrice called', 'nothing');
        
        commercestorepricing.PricingRequestItemCollection items = request.getPricingRequestItems();
        for (Integer i = 0; i < items.size(); i++) {
          commercestorepricing.PricingRequestItem item = items.get(i);
          products.add(item.getProductId());
        }
        
        //ExternalMockAPI.callExternalService('PricingService', req);
        //ExternalMockAPI.getPricesFromExternalService(products);
        // Encode the product IDs to avoid any invalid characters in the URL.
        Set<String> encodedProductIDs = new Set<String>();
        for (String productID : products) {
          encodedProductIDs.add(EncodingUtil.urlEncode(productID, 'UTF-8'));
        }
        
        log('processPrice products','');    
            
        // To access the service below, you may need to add endpoint =
        // https://b2b-commerce-test.herokuapp.com in Setup > Security > Remote site settings.
        String params ='?skus=' + JSON.serialize(encodedProductIDs);
    
        String url = 'https://g2jazatfd6xv55hclhmi4lsghm0geazp.lambda-url.us-east-1.on.aws';
        
           log('processPrice url=',url);    
            
        String data = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Integer SuccessfulHttpRequest = 200;    
        
        String requestURL = url;
    //    req.setHeader('content-type', 'application/json');
        req.setEndpoint(requestURL);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        
         System.debug('In commercestorepricing.PricingService processPrice http resonse res=' + res.getStatusCode());
    
        if (res.getStatusCode() == SuccessfulHttpRequest) {
        
            System.debug('In getDataFromExternalService, success');
            data = res.getBody();
            }else{
                
                System.debug('In getDataFromExternalService, error');
        }
    
        log('got data=', String.valueOf(data));
    
        Map<String, ProductData> productMap = new Map<String, ProductData>();
    
        List<Object> jsonList = (List<Object>) JSON.deserializeUntyped(data);
    
        log('got data=', String.valueOf(jsonList));
        
        System.debug(jsonList);
        
        for (Object obj : jsonList) {
            Map<String, Object> jsonMap = (Map<String, Object>)obj;
            ProductData product = new ProductData();
            product.id = (String) jsonMap.get('id');
            product.listPrice = (Decimal) jsonMap.get('listPrice');
            product.unitPrice = (Decimal) jsonMap.get('unitPrice');
            productMap.put(product.id, product);
        }
        
        log('before loop', String.valueOf(productMap));
            
        for(String productId : products) {
              // Print each element in the set
              System.debug(productId);
              log('inside loop productId=', String.valueOf(productId));
              
              ProductData product = (ProductData) productMap.get(productId);
              System.debug('mapped product--'+product);
              log('inside loop got product=', String.valueOf(productId));
              
              if (product == null) {
              
                log('inside loop, product not found', String.valueOf(product));
              
                // Unsuccessful response item
                commercestorepricing.PricingResponseItem responseItem = new commercestorepricing.PricingResponseItem(
                  productId,
                  null,
                  null,
                  null,
                  null
                );
                responseItem.setError(
                  'No prices available for this product.',
                  'Für dieses Produkt sind keine Preise verfügbar.'
                );
                response.addPricingResponseItem(responseItem);
              } else {
                // Successful response item
             
                  log('inside loop, product found', String.valueOf(product));
                           
                commercestorepricing.PricingResponseItem responseItem = new commercestorepricing.PricingResponseItem(
                  productId,
                  null,
                  null,
                  product.listPrice,
                  product.unitPrice
                );
                response.addPricingResponseItem(responseItem);
              }            
        }
    
        }catch(Exception e){
          System.debug('Error getDataFromExternalService--'+e.getMessage());
        }finally{
            System.debug('Finally getDataFromExternalService');
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