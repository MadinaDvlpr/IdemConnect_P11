@isTest
public class OrderServiceTest {
    private static String accountName = 'Madina';
    private static String accountOneOrder = 'AccountTest';
    private static String productName = 'Bidule';
    private static String pricebookName = 'Madina\'s Price Book';
    private static String orderName = 'MyOrderTest';
    
     @testSetup
    static void setupForTaskReminderTest(){
        TestDataFactory.createAccount(accountName, true);
        Account accountForThisTest = AccountSelector.getAccount(accountName);
        List <Pricebook2> pricebooksForThisTest = TestDataFactory.createPricebook(pricebookName);
        List <Product2> productsForThisTest = TestDataFactory.createProduct(productName);
       PricebookEntry pricebookEntryForThisTest = TestDataFactory.createPriceBookEntry(productsForThisTest[0].Id, 1);
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(20, accountForThisTest.Id);
    }
    
@isTest
    static void testOrderListStatusDraftToActivated(){
        Id orderId = testDataFactory.getFakeId(Order.SObjectType);
		Order orderDraft = new Order(Status= 'Draft', Id = orderId);  
        Order orderActivated = new Order(Status= 'Activated', Id = orderId);        
        Map<Id, Order> ordersMapOld = new Map<Id, Order>(new List<Order> {orderDraft});
		Map<Id, Order> ordersMapNew = new Map<Id, Order>(new List<Order> {orderActivated});
      
        Test.startTest();
        List<Order> ordersListToTest = OrderService.ordersListStatusDraftToActivated(ordersMapOld, ordersMapNew);
        Test.stopTest();
        
        System.assertEquals('Activated', ordersListToTest[0].Status, 'OrderService.ordersListStatusDraftToActivated should return a List of orders with status set to Activated.');
    }

}