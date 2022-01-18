@isTest
private class F_PurgeBatchTest {
	@testSetup
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
    
    @isTest static void test() {
        FieloPLT.CacheAPI.enableCacheAccess(false);
        
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;

        //update adminUser;

        system.runAs(adminUser){
            Test.startTest();
            F_PurgeBatch pb = new F_PurgeBatch();
            Id batchId = Database.executeBatch(pb);
            
            F_PurgeBatch pb1 = new F_PurgeBatch(1);
            Id batchId1 = Database.executeBatch(pb1);
            
            F_PurgeBatch pb2 = new F_PurgeBatch(2);
            Id batchId2 = Database.executeBatch(pb2);
            
            F_PurgeBatch pb3 = new F_PurgeBatch(3);
            Id batchId3 = Database.executeBatch(pb3);
            Test.stopTest();
        }
    }
}