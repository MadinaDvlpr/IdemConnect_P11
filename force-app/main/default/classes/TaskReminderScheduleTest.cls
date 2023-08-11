@IsTest
private class TaskReminderScheduleTest {
    public static String CRON_EXP = '0 0 0 ? * 2#1';
    public static String JOB_NAME = 'Scheduled Apex Test';
    
    @IsTest
    static void testScheduledJob() {  
        List<Account> account  = TestDataFactory.createAccounts(10);
        
        //Get the IDs of the accounts inserted
        List<Id> accountIds = new List<Id>(new Map<Id, Account>(account).keySet());   
        
        Test.startTest();        
        String jobId = System.schedule(JOB_NAME,
                                       CRON_EXP,
                                       new TaskReminderSchedule());
        //A VERIFIER
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime,CronJobDetailId,State FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(
            1,
            [
                SELECT COUNT()
                FROM CronTrigger
                WHERE CronJobDetail.JobType = '7' AND CronJobDetail.Name = :JOB_NAME
            ]
        );
        
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(
            0,
            [SELECT Id FROM Task WHERE WhatId IN :accountIds].size(),
            'Tasks exist before job has run'
        );
        
        //revoir pris sur salesforce help pas sure du resultat
        Date jobRunDate = Date.today().addMonths(1).toStartOfMonth().toStartOfWeek();
          
        
        if (jobRunDate < date.today().addMonths(1).toStartOfmonth()) {
            jobRunDate = jobRunDate.addDays(7);
        }
        
        System.assertEquals(ct.NextFireTime.date(), jobRunDate);
        
        
        Test.stopTest();        
    }
}