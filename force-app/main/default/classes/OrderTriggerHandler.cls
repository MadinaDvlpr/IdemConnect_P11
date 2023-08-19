public with sharing class OrderTriggerHandler {

        public void run() {
            List<Order> newOrders = Trigger.new;
            List<Order> oldOrders = Trigger.old;
            
            Map<Id, Order> orderMapOld = (Map<Id, Order>)Trigger.oldMap;
            Map<Id, Order> orderMapNew = (Map<Id, Order>)Trigger.newMap;
            
            if ((Trigger.isBefore && Trigger.isUpdate) && (Trigger.isBefore && Trigger.isInsert)) {

                OrderTriggerHelper.checkOrdersWithProducts(orderMapNew, orderMapOld);
            } else if (Trigger.isAfter && Trigger.isDelete) {
                 OrderTriggerHelper.checkAccountsWhenOrdersDeleted(oldOrders);
            }   
        }
    }