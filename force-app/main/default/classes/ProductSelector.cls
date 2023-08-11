public with sharing class  ProductSelector {
	public static Product2 getProduct(String productName){
        Product2 productToReturn = [SELECT Id,
                                    Name,
                                    IsActive
                                    FROM Product2
                                    WHERE Name = :productName
                                    LIMIT 1];
        return productToReturn;
    }
    
    public static List<Product2> getProductListByName(String productName){
        List<Product2> productListToReturn = [SELECT Id,
                                                        Name,
                                                        IsActive
                                                FROM Product2
                                                WHERE Name = :productName];
        return productListToReturn;
    }

}