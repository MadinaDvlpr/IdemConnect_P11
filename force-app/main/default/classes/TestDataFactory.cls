@isTest
public class TestDataFactory {
    public static Account createAccount(String accountName, Boolean insertData) {
        Account account = new Account( Name = accountName);
        if(insertData){
            insert account;
        }
        return account;
    }

    public static void createAccount(){
        Account accountCreated = new Account(Name = 'accountName');
        insert accountCreated;
    }
    
    public static List<Account> createAccounts(Integer numberOfaccounts) {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0 ; i < numberOfaccounts; i++) {
            accounts.add(new Account(Name = 'accountName-'+i));
        }
        insert accounts;
        return accounts;
    }
   
    public static void createAccountsList(Integer numberOfAccounts){
        List<Account> accountsListToInsertForTest = new List<Account>();
        for(Integer i = 0 ; i < numberOfAccounts ; i++){
            accountsListToInsertForTest.add(new Account(Name = 'accountName-'+i));
        }
        insert accountsListToInsertForTest;
    }

    
    public static Product2 createProduct() {
        Product2 product = new Product2(
            IsActive =true,
            Name = 'ProductTest'
        );
        insert product;
        return product;
    }
    
            
    public static Order createOrder(Id accountId){         
        Order order = New Order (
            AccountId = accountId,
            Status ='Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );       
        insert order;
        return order;   
    }
    
    public static Order createOrder(String orderName, Id accountID, Id contractID, Id pricebookId){
        Order orderCreated = new Order(
            Name = orderName,
            AccountId = accountID, //Required
            ContractId = contractID,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            // essential for the creation of OrderItem
            Pricebook2Id =  pricebookId //Required
            //TotalAmount = not writable This is Why Order links to a Product2 with OrderItem
        );
        return orderCreated;
    }
    
    public static List<Order> createOrders(Account account, PricebookEntry pricebookEntry, Integer numberOrder) {
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < numberOrder; i++){
            Order order = TestDataFactory.createOrder(account.Id);
            order.Name='OrdersTest'+i;
            orders.add(order);
        }
        update orders;
        return orders;
    }     
    
    public static List<Order> createAccountWithOrders(Integer numberOrders, Id accountId){
        List<Order> ordersList = new List<Order>();
        
        for(Integer i=0; i<numberOrders; i++) {
            Order order = new Order(
                AccountId = accountId,
                Pricebook2Id = Test.getStandardPricebookId(),
                status = 'Draft',
                effectiveDate = Date.today()
            );
            ordersList.add(order);
            
        }
        insert ordersList;        
        
        Product2 product2 = TestDataFactory.createProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product2.Id, 100);
        List<OrderItem> items = new List<OrderItem>();
        
        for(Order orderCurrent: ordersList) {
            OrderItem item = new OrderItem (OrderId = orderCurrent.Id, PricebookEntryId = pricebookEntry.Id, Quantity=1, UnitPrice = 100);
            items.add(item);
        }
        
        insert items;     
        update ordersList;
        return ordersList;
    }
    
    
    public static List<PriceBook2> createPricebook(String pricebookName){
        List<PriceBook2> pricebookToInsert = new List<PriceBook2>();
        pricebookToInsert.add( new PriceBook2 (
            Name = pricebookName,
            IsActive = true
        ));
        insert pricebookToInsert;
        return pricebookToInsert;
    }
    
    public static PricebookEntry createPricebookEntry(Id productId, Decimal amount) {
        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = amount,
            IsActive = false
        );
        insert priceBookEntry;
        return priceBookEntry;     
    }    
    
    public static PricebookEntry createPriceBookEntry(PriceBook2 pricebookForThisTest, Product2 productForThisTest){
        PricebookEntry priceBookEntryToInsert = new PricebookEntry(
            Pricebook2Id = pricebookForThisTest.Id,
            Product2Id = productForThisTest.Id,
            UnitPrice = 100.00,
            IsActive = true,
            UseStandardPrice = false);
        
        insert priceBookEntryToInsert;
        return priceBookEntryToInsert;
    }
    
    public static void createPriceBookEntryForPricebookStandard(Product2 productForThisTest){
        PricebookEntry priceBookEntryToInsert = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productForThisTest.Id,
            UnitPrice = 120.00,
            IsActive = true
        );
        insert priceBookEntryToInsert;
    }
    
    public static List<Product2> createProduct(String productName){
        List<Product2> productsToInsert = new List<Product2>();
        productsToInsert.add(new Product2 (
            Name = productName,
            IsActive = true
        ));
        insert productsToInsert;
        return  productsToInsert;
    }
    
    public static Contract createContract(Id accountID){
        Contract contract = new Contract(
                AccountId = accountID,
                //can't create a contract with the Status set to Activated
                Status = 'Draft',
                StartDate = Date.today(),
                ContractTerm = 6
            );
            return contract;
    }
    public static void createContractsList(List<Account> accountsList){
        List<Contract> contractsList = new List<Contract>();

        for(Account accountCurrent : accountsList){
            contractsList.add(createContract(accountCurrent.Id));
        }
    }
    
     public static OrderItem createOrderItem(Id orderId, Id productId, Id pricebookEntryId){
        OrderItem orderItemToInsert = new OrderItem(
            OrderId = orderId,
            Quantity = 24,
            UnitPrice = 240,
            Product2Id = productId,
            PricebookEntryId = pricebookEntryId //Required

        );
        return orderItemToInsert;
    }
    
    public static List<OrderItem> createOrderItemsList(List<Order> orderList, Id product2Id, Id pricebookEntryId){
        List<OrderItem> orderItemsList = new List<OrderItem>();
        for(Order orderCurrent : orderList){
            //(Order orderForThisTest, Product2 product2ForThisTest, PricebookEntry pricebookEntryForThisTest)
            orderItemsList.add(TestDataFactory.createOrderItem(orderCurrent.Id, product2Id, pricebookEntryId));
        }        
        
            insert orderItemsList;
        return orderItemsList;
        
    }


}