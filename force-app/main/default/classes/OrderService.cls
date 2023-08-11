public  with sharing class OrderService {
    public static List<Order> ordersListStatusDraftToActivated(Map<Id, Order> orderMapOld, Map<Id, Order> orderMapNew) {
            Set<Order> orderSetToReturn = new Set<Order>();
                for(Order orderCurrentNew : orderMapNew.values()){
                    Order orderCurrentOld = orderMapOld.get(orderCurrentNew.Id);
                    if( orderCurrentOld.Status == 'Draft'
                        && orderCurrentNew.Status == 'Activated'){
                            orderSetToReturn.add(orderCurrentNew);
                        }
                }
            return new List<Order>(orderSetToReturn);
        }

}