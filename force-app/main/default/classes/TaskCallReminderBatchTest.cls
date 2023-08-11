@isTest
public class TaskCallReminderBatchTest {
    // init class variables
    private static String accountName = 'Test Account';

    
     @testSetup
    static void setupForTaskReminderTest(){
        TestDataFactory.createAccount(accountName, true);       
    }
 
   
     @isTest static void testExecuteBatch() {
         
        Test.startTest();
        TaskCallReminderBatch batch = new TaskCallReminderBatch();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();

       	List<Task> TasksReminder = [SELECT WhatId, Status, Subject, Priority, OwnerId, IsReminderSet, ReminderDateTime
                                    FROM Task WHERE Type = 'Call'];
        System.assertEquals(1, TasksReminder.size());
    }
    
    

}