public with sharing class PricebookSelector {
    public static Pricebook2 getPriceBookByName(String pricebookName){
  
        Pricebook2 pricebookForThisTest = [SELECT Id,
                                                Name,
                                                isActive,
                                                IsStandard
                                            FROM PriceBook2
                                            WHERE Name = :pricebookName];
        return pricebookForThisTest;
    }
    
    public static List<Pricebook2> getPriceBookListByName(String pricebookName){
        List<Pricebook2> pricebookList = [SELECT Id,
                                                Name,
                                                isActive,
                                                IsStandard
                                            FROM PriceBook2
                                            WHERE Name = :pricebookName];
        return pricebookList;
    }
    
   
    
    
}