@isTest
public class OrderTriggerHelperTest {
    // init class variables
    private static String productName = 'Test';
    private static String pricebookName = 'accountName-1\'s Price Book';
    private static String orderName = 'accountName-1\'s Order';
    private static String accountName = 'accountName-1';


    // set up
    @TestSetup
    static void setupFor_OrderTriggerHelperTest() {
        TestDataFactory.createAccounts(5);
        TestDataFactory.createPricebook(pricebookName);
        TestDataFactory.createProduct(productName);
        TestDataFactory.createAccount(accountName, true);
        

    }

    @isTest
    public static void testCheckOrdersWithProducts(){
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        TestDataFactory.createPriceBookEntryForPricebookStandard(productForThisTest);
        TestDataFactory.createPriceBookEntry(pricebookForThisTest, productForThisTest);
        //recup commandes det comptes
        List<Order> ordersList = OrderSelector.getOrdersAll();
        List<Account> accountsList = AccountSelector.getAccountsAll();

		//prevoir tests negatifs
		//utiliser la fonction database.insert database.update (est ce qu'on insert tt ou pas ? 
		//database save result succes ou erreur 
		//regarder si y'a une erreur )
		//
		//
		List<Order> ordersListForThisTest = [
            SELECT Id, AccountId, Status, (
                SELECT Id, UnitPrice, Quantity, OrderId
                FROM OrderItems
            )
            FROM Order
        ];
        
        for (Order orderCurrent : ordersListForThisTest) {
            orderCurrent.Status = 'Activated';//We want to change the status to activated
            delete orderCurrent.OrderItems;//We add to manually delete the order items create by the TestDataFactory
        }
        
        Test.startTest();
        
        try {
            update ordersListForThisTest;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            Boolean expectedMessage = e.getMessage().contains('Please add at least one product to the order before changing status') ? true : false;
            
            System.assertEquals(expectedExceptionThrown, true);
            System.assertEquals(expectedMessage, true);
        }
        
        Test.stopTest();
        ordersListForThisTest = [
            SELECT Id, AccountId, Status, (
                SELECT Id, UnitPrice, Quantity, OrderId
                FROM OrderItems
            )
            FROM Order];

        
        for (Order orderCurrent : ordersListForThisTest) {
            System.assertEquals('Draft', orderCurrent.Status);
        }
    }
    

    @isTest
    static void testSetActiveAccountWithOrders(){
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        TestDataFactory.createPriceBookEntryForPricebookStandard(productForThisTest);
        TestDataFactory.createPriceBookEntry(pricebookForThisTest, productForThisTest);
        
        TestDataFactory.createAccount('New Account Test', true);
        Account accountTest = AccountSelector.getAccount('New Account Test');
        List <Order> ordersListForAccount = TestDataFactory.createAccountWithOrders(50, accountTest.Id);
        
        /**recup commandes et comptes
        List<Order> ordersList = OrderSelector.getOrdersAll();
        List<Account> accountsList = AccountSelector.getAccountsAll();
        **/
        
            
            Test.startTest();
            List<Account> accountsListToTest = OrderTriggerHelper.setActiveAccountWhenOrdersActivated(ordersListForAccount);

            Test.stopTest();
            
            for (Account account : accountsListToTest) {
                System.assertEquals(true, account.Active__c);
            }
    }
    
     @isTest
    static void testCheckAccountsWhenOrdersDeleted(){
		Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        TestDataFactory.createPriceBookEntryForPricebookStandard(productForThisTest);
        TestDataFactory.createPriceBookEntry(pricebookForThisTest, productForThisTest);
        
        Account accountTest = TestDataFactory.createAccount(accountName, false);
        accountTest.Active__c = true;
        insert accountTest;
        
        List <Order> ordersListForAccount = TestDataFactory.createAccountWithOrders(2, accountTest.Id);
             //pas de upsert update ou delete dans for
            
       Test.startTest();
       delete ordersListforAccount;
       Test.stopTest();
           accountTest = [SELECT Active__c FROM Account WHERE Id =:accountTest.Id];
        System.debug(accountTest);
          System.AssertEquals(accountTest.Active__c, false);

    }
    @IsTest
    static void testNoItemsInOrderReturnError() {
        List<Order> orders = [
            SELECT Id, AccountId, Status, (
                SELECT Id, UnitPrice, Quantity, OrderId
                FROM OrderItems
            )
            FROM Order
            WHERE Name LIKE 'Order_%'
        ];
        
        for (Order order : orders) {
            order.Status = 'Activated';
            delete order.OrderItems;
        }
        
        Test.startTest();
        
        try {
            update orders;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            Boolean expectedMessage = e.getMessage().contains('Please add at least one product to the order before changing status') ? true : false;
            
            System.assertEquals(expectedExceptionThrown, true);
            System.assertEquals(expectedMessage, true);
        }
        
        Test.stopTest();
        orders = [
            SELECT Id, AccountId, Status, (
                SELECT Id, UnitPrice, Quantity, OrderId
                FROM OrderItems
            )
            FROM Order
            WHERE Name LIKE 'Order_%'
        ];
        
        for (Order orderCurrent : orders) {
            System.assertEquals('Draft', orderCurrent.Status);
        }
    }
    
    @IsTest
    static void testItemsInOrderReturnNoError() {
        List<Order> orders = [
            SELECT Id, AccountId, Status, (
                SELECT Id, UnitPrice, Quantity, OrderId
                FROM OrderItems
            )
            FROM Order
            WHERE Name LIKE 'Order_%'
        ];
        
        
        for (Order orderCurrent : orders) {
            orderCurrent.Status = 'Activated';
            
        }
        
        Test.startTest();
        try {
            update orders;
            
        } catch (Exception e) {
            
            System.debug(e);
            
        }
        Test.stopTest();
        orders = [
            SELECT Id, AccountId, Status, (
                SELECT Id, UnitPrice, Quantity, OrderId
                FROM OrderItems
            )
            FROM Order
            WHERE Name LIKE 'Order_%'
        ];
        
        for (Order orderCurrent : orders) {
            System.assertEquals('Activated', orderCurrent.Status);
        }
    }
    
    @IsTest
    static void testCheckForTaskCall(){
        
    }
}