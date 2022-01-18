@isTest
private class F_PurgeBatchSchedulerTest {
    @TestSetup
    static void setup(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;
        //update adminUser;
        
        
        system.runAs(adminUser){
            Account portalAccount = new Account();
            portalAccount.Name = 'TestAccount';
            insert portalAccount;
            
            Recordtype recordtype = [Select ID from Recordtype  where DeveloperName ='Contact' LIMIT 1];
            
            Contact contact1 = new Contact();
            contact1.FirstName = 'Test';
            contact1.Lastname = 'Test';
            contact1.AccountId = portalAccount.Id;
            contact1.Email = 'test@fielo.com';
            contact1.RecordTypeId = recordtype.Id;
            insert contact1;         
            
            Profile prof = F_SObjectForTest.getProfile('system administrator');
            User u = F_SObjectForTest.getUser(prof.Id,'tst');
            insert u;
            
            FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
            insert program;
            
            Id groupId = FieloSObjectFactory.createTestGroup('Test' + String.valueOf(Datetime.now()));
            
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, u.Id, contact1.Id);
            member.Group_ID__c = groupId;
            insert member;
            
            FieloPLT__Transaction__c transac = F_SObjectForTest.getTransaction(member.Id);
            insert transac;
            
            FieloPLT__Promotion__c promotion = F_SObjectForTest.getPromotion(program.Id);
            insert promotion;
            
            FieloPLT__RuleTrigger__c ruleTrigger = F_SObjectForTest.getRuleTrigger();
            insert ruleTrigger;            
            
            FieloPLT__Action__c action = F_SObjectForTest.getAction(ruleTrigger.Id);
            insert action;
            
            FieloPLT__Rule__c rule = F_SObjectForTest.getRule('TestRule', promotion.Id, action.Id);
            insert rule;
            
            FieloPLT__Point__c pt = F_SObjectForTest.getPoint(member.Id, rule.Id, transac.Id);
            insert pt;
            
     		Chatter_Event__c event = FieloSObjectFactory.createEvent(member.Id, groupId, 'Write a post', 'Test');
			insert event;            
         
        }
    }    
    
    @isTest
    static void test() {
        String CRON_EXP = '0 0 23 * * ?';
        F_purgeEventScheduler b0 = new F_purgeEventScheduler();
        F_purgePointScheduler b1 = new F_purgePointScheduler();
        F_purgeTransactionScheduler b2 = new F_purgeTransactionScheduler();
        F_purgeLeaderboardScheduler b3 = new F_purgeLeaderboardScheduler();
        Test.startTest();
        String job0 = System.schedule('ScheduledApexTest', CRON_EXP, b0);
        String job1 = System.schedule('ScheduledApexTest1', CRON_EXP, b1);
        String job2 = System.schedule('ScheduledApexTest2', CRON_EXP, b2);
        String job3 = System.schedule('ScheduledApexTest3', CRON_EXP, b3);
        Test.stopTest();
    }
}