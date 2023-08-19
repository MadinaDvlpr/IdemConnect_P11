public with sharing class OrderSelector {
   
    public static List<Order> getOrdersAll(){
        List<Order> orderList = [SELECT Id, 
                                        AccountId, 
                                        TotalAmount, 
                                        ShippingCost__c,
                                        NetAmount__c,
                                        Status
                                  FROM Order];
        return orderList;
    }
}