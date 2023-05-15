@isTest
global class PricingDemoServiceTest {
    @testSetup static void setup() {
        Account testAccount = new Account(Name='TestAccount');
        insert testAccount;
        WebStore testWebStore = new WebStore(Name='TestWebStore');
        insert testWebStore;
    }
    
    @isTest static void testProcessPriceIntegration() {
        System.debug('In PricingDemoServiceTest testProcessPriceIntegration');        
        // Because test methods don't support web service callouts, we create a mock response based on a static resource.
        // To create the static resource from the Developer Console, select File | New | Static Resource

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
    
    /*
    @isTest static void testProcessPriceIntegrationWithError() {
        // Because test methods don't support web service callouts, we create a mock response based on a static resource.
        // To create the static resource from the Developer Console, select File > New > Static Resource
        System.debug('In PricingDemoServiceTest testProcessPriceIntegrationWithError');

        // Create request
        Account account = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name='TestWebStore' LIMIT 1];
        
        commercestorepricing.PricingRequestItem requestItem = new commercestorepricing.PricingRequestItem('UnknownProductID');
        commercestorepricing.PricingRequest request = new commercestorepricing.PricingRequest();
        request.setWebStoreId(webStore.Id);
        request.setEffectiveAccountId(account.Id);
        request.addPricingRequestItem(requestItem);
        
        // Test: execute the pricing integration for the test request.
        PricingDemoService apexSample = new PricingDemoService();
        commercestorepricing.PricingResponse response = apexSample.processPrice(request);
        // Verify: the integration executed successfully
        //System.assertEquals(true, response.isSuccess());
        //System.assertEquals(1, response.getPricingResponseItems().size());
        //System.assertEquals(false, response.getPricingResponseItems().get(0).isSuccess());
        Test.stopTest();
    }
    */
    
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