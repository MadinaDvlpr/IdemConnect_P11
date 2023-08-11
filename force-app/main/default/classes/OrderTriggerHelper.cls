public with sharing class OrderTriggerHelper {
    //RG-01 : check if the Order is linked to an actual Product.
        public static void checkOrdersWithProducts(Map<Id, Order> newMap, Map<Id, Order> oldMap) {
   		
            
            for (Order orderCurrent : newMap.values()) {        
                if (orderCurrent.OrderItems.size() == 0 && (oldMap == null || orderCurrent.Status != oldMap.get(orderCurrent.Id).Status)) { 
                    orderCurrent.addError('Please add at least one product to the order before changing status');
                    } else{
                    orderCurrent.Status= 'Activated';
                }
            }           
        }

  //RG-O2 : check if Account has orders linked and update status to Active.
   public static List<Account> setActiveAccountWhenOrdersActivated(List<Order> createdOrders){
   Set<Id> accountsIds = new Set<Id>();
       
        for (Order order : createdOrders) {
            accountsIds.add(order.AccountId);
        } 
        List<Account> accountsToActivate = new List<Account>();
       
        for (Account account : [SELECT Id,(SELECT Id FROM Orders) FROM Account WHERE Id IN :accountsIds]) {
            if (account.Orders.size() > 0) {
                account.Active__c = true;
                accountsToActivate.add(account);
            }
        }
        update accountsToActivate;
       return accountsToActivate;
    }

   //RG-O2 : check that account still have order linked after deleting an order and set to inactive if not
   public static void checkAccountsWhenOrdersDeleted(List<Order> deletedOrders){
     Set<Id> accountsIds = new Set<Id>();
        for (Order order : deletedOrders) {
            accountsIds.add(order.AccountId);
        }
        List<Account> accountsToUpdate = new List<Account>();
       System.debug(accountsIds);
        for (Account account : [SELECT Id, (SELECT Id FROM Orders) FROM Account WHERE Id IN :accountsIds]) {
            if (account.Orders.size() == 0) {
                account.Active__c = false;
                accountsToUpdate.add(account);
            }
        }
        update accountsToUpdate;		
    }
    
    //RG 03 requete imbriquee pour retourner tous les comptes sans commandes et pas activité type appel
    public static void checkForTaskCall(List<Account> accountsWithoutTask){    
        List<Account> accountsWithoutCall = new List<Account>();
        
        for (Account account : accountsWithoutTask) {
            if (account.Orders.size() == 0 && account.Tasks.size() == 0) {
                accountsWithoutCall.add(account);
            }
        }
        
        System.debug(accountsWithoutCall);
 
            List<Task> tasksToCreate = new List<Task>();
        
            for (Account account : accountsWithoutCall) {
                tasksToCreate.add(
                    new Task(WhatId = account.Id, 
                             OwnerId = account.OwnerId, 
                             Subject = 'Call',
                             Type = 'Call', 
                             Status = 'Not Started', 
                             Priority = 'Normal', 
                             IsReminderSet = true, 
                             ReminderDateTime = Date.today().addDays(5)));
            }
                insert tasksToCreate;
   
        
    }
}