public class ContractSelector {
     /**public static List<Contract> getContractsAll() {
        List<Contract> contractsListToReturn = [SELECT Id,
                                                        Name,
                                                        AccountId,
                                                        Status
                                                FROM Contract];

        return contractsListToReturn;
    }
    public static List<Contract> getContractsForAccount(Id accountId){
       
        List<Contract> contractsListToReturn = [SELECT Id,
                                                        Name,
                                                        AccountId,
                                                        Status
                                                FROM Contract
                                                WHERE AccountId = :AccountId];
        return contractsListToReturn;

    }
**/

}