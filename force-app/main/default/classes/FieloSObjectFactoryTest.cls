@isTest
private class FieloSObjectFactoryTest {
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
            
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, u.Id, contact1.Id);
            insert member;
            
        }       
    }
    
	@isTest
    static void createEventTest1(){
        
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;
        //update adminUser;
        
        
        system.runAs(adminUser){
            FieloPLT__Member__c member = [select id from FieloPLT__Member__c];
            Id groupId = FieloSObjectFactory.createTestGroup('TestFielo1');
            Test.startTest();
            Chatter_Event__c event = FieloSObjectFactory.createEvent(member.Id, groupId, 'Test', 'Test');
            System.assertEquals('Test', event.Group_Name__c);
            Test.stopTest();
        }
    }
    
    @isTest 
    static void createEventTest2(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;
        //update adminUser;


        
        system.runAs(adminUser){
            FieloPLT__Member__c member = [select id from FieloPLT__Member__c];
            Id groupId = FieloSObjectFactory.createTestGroup('TestFielo2');
            Test.startTest();
            Chatter_Event__c event = FieloSObjectFactory.createEvent(member.Id, groupId, 'Test', 'Test', userInfo.getUserId());
            System.assertEquals('Test', event.Group_Name__c);
            Test.stopTest();
        }
    }
    
    @isTest
    static void createGeneralMemberTest(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;
        //update adminUser;
        
        
        system.runAs(adminUser){
            FieloPLT__Program__c program = [select id from FieloPLT__Program__c];
            Test.startTest();
            FieloPLT__Member__c member2 = FieloSObjectFactory.createGeneralMember('test@fielo.com', program.Id, userInfo.getUserId(), 'Test');
            System.assertEquals('Test', member2.Name);
            Test.stopTest();
        }
    }
}