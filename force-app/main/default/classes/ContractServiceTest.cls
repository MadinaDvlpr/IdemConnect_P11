@isTest

public class ContractServiceTest {
    @TestSetup
    static void setupContractGet(){
        TestDataFactory.createAccountsList(5);
        List<Account> accountsList = AccountSelector.getAccountsAll();
        TestDataFactory.createContractsList(accountsList);
    }

}