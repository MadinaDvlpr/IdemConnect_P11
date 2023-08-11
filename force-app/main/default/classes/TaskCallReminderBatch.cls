global class TaskCallReminderBatch implements Database.Batchable<sObject>, Schedulable {
    public static String CRON_EXP = '0 0 0 ? * 2#1 *';
    
    global void execute(SchedulableContext sc){
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        
        TaskCallReminderBatch reminder = new TaskCallReminderBatch();
        database.executeBatch(reminder);
    }

    global Database.QueryLocator start(Database.BatchableContext info) {
        
        //probleme avec la query
        String query = 'SELECT Id, OwnerId, (SELECT Id FROM Tasks WHERE Type = \'Call\') FROM Account WHERE Active__c = false';
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext info, List<Account> scope) {
        //pas d'appel de classe trigger dans execute
        
        OrderTriggerHelper.checkForTaskCall(scope);
    }
    
    //finish à vérifier
    global void finish(Database.BatchableContext info) {
        
    }
}