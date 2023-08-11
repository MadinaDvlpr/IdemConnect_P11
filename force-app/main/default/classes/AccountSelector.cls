public with sharing class AccountSelector {
     //get one account
     public static Account getAccount(String accountName) {
        Account accountToReturn = [
                SELECT Id,
                        Name
                FROM Account
                WHERE Name = :accountName
                LIMIT 1
        ];
        return accountToReturn;
    }

    //get all accounts
    public static List<Account> getAccountsAll() {
        List<Account> accList = [
                SELECT Id,
                        Name
                FROM Account
        ];
        return accList;
    }


}