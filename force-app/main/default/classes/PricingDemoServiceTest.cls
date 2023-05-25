@isTest
global class PricingDemoServiceTest {
    @testSetup static void setup() {
        Account testAccount = new Account(Name='TestAccount');
        insert testAccount;
        WebStore testWebStore = new WebStore(Name='TestWebStore');
        insert testWebStore;

        // Instantiate the Pricebook2 record first, setting the Id
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        // Run an update DML on the Pricebook2 record
        // This is the weird workaround that enables IsStandard to become true
        // on the PricebookEntry record
        update standardPricebook;
        
        // Re-Query for the Pricebook2 record, for debugging
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
                
        // Create the Product
        Product2 testProduct = new Product2(
            Name = 'P1', 
            IsActive = true
        );
        insert testProduct;
        
        // Create the PricebookEntry
        PricebookEntry testPbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        
        insert testPbe;
    }
    
    @isTest static void testProcessPriceIntegration() {
        System.debug('In PricingDemoServiceTest testProcessPriceIntegration');        

        // Create request
        Account account = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name='TestWebStore' LIMIT 1];
        
        commercestorepricing.PricingRequestItem requestItem = new commercestorepricing.PricingRequestItem('ProductID1');

        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.setWebStoreId(webStore.Id);
        request.setEffectiveAccountId(account.Id);
        request.addPricingRequestItem(requestItem);

        Test.startTest();
        // Test: execute the pricing integration for the test request.
        PricingDemoService apexSample = new PricingDemoService();
        commercestorepricing.PricingResponse response = apexSample.processPrice(request);
        // Verify: the integration executed successfully
        System.assertEquals(true, response.isSuccess());
        System.assertEquals(1, response.getPricingResponseItems().size());
        Test.stopTest();
    }

    //    public override commercestorepricing.TransactionalPricingResponse processTransactionalPrice(
        //commercestorepricing.TransactionalPricingRequest request


    @isTest static void testProcessTransactionalPrice() {
        System.debug('In PricingDemoServiceTest testProcessTransactionalPrice');        

        // Create request
        Account account = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name='TestWebStore' LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 WHERE Name='P1' LIMIT 1];
                
        String lineId=product.Id;
        String productId = product.Id;
        Decimal quantity = 100;

        Test.startTest();

        commercestorepricing.TransactionalPricingRequest request = new commercestorepricing.TransactionalPricingRequest();
        commercestorepricing.TransactionalPricingRequestItem requestItem = new commercestorepricing.TransactionalPricingRequestItem( lineId,  productId,  quantity);                 
        request.setWebStoreId(webStore.Id);
        request.setEffectiveAccountId(account.Id);
        request.setCurrencyIsoCode('USD');
        request.addTxnPricingRequestItem(requestItem); 
        
        PricingDemoService apexSample = new PricingDemoService();
        commercestorepricing.TransactionalPricingResponse response = apexSample.processTransactionalPrice(request);
        // Verify: the integration executed successfully
        //System.assertEquals(true, response.isSuccess());
        //System.assertNotEquals(1, response.getTotalAmount());
        Test.stopTest();
    }


    @isTest static void testAppendField(){
        System.debug('In PricingDemoServiceTest testAppendField');
    
       Test.startTest();
       String prefix = '1';
       String field = 'value';
       PricingDemoService apexSample = new PricingDemoService(); 
       String output = apexSample.appendField(prefix, field);
       System.assertEquals(prefix+field, output);
       Test.stopTest();
    }

}