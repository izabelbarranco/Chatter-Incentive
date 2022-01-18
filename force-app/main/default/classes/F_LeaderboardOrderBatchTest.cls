@isTest
public class F_LeaderboardOrderBatchTest {
	@testSetup
    static void setup(){
        user u = [select id, userroleid from user where profile.name = 'System Administrator' LIMIT 1];
        
        permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdminClone'];
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :u.Id 
                                             AND PermissionSetId = :ps3.Id];
        if(psa.size() == 0){
            insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps3.Id);
        }

		system.runAs(u){
            
            Recordtype recordtype = [Select ID from Recordtype where DeveloperName ='Contact' LIMIT 1];
            
            Profile prof = F_SObjectForTest.getProfile('system administrator');
            User u2 = F_SObjectForTest.getUser(prof.Id);
            u2.Username = 'testc@fielo.com';
            insert u2;
            
            FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
            insert program;
            
            Id groupId = FieloSObjectFactory.createTestGroup('Test_LBoardList');
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member1', program.Id, u.Id);
            member.Group_ID__c = groupId;
            insert member;
            
            Id groupId2 = FieloSObjectFactory.createTestGroup('Test_LBoardList2');
            FieloPLT__Member__c member2 = F_SObjectForTest.getMember('Test Member2', program.Id, u.Id);
            member2.Group_ID__c = groupId2;
            
            FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
            trig.SetupOwnerId = userInfo.getUserId();
            trig.FieloPLT__Member__c = false;
            insert trig;
            
            insert member2;
            
             FieloPLT__Promotion__c promotion = F_SObjectForTest.getPromotion(program.Id);
            insert promotion;
            
            FieloPLT__RuleTrigger__c ruleTrigger = F_SObjectForTest.getRuleTrigger();
            insert ruleTrigger;
            
            FieloPLT__Action__c action = F_SObjectForTest.getAction(ruleTrigger.Id);
            insert action;
            
            FieloPLT__Rule__c rule = F_SObjectForTest.getRule('TestRule', promotion.Id, action.Id);
            insert rule;
            
            List<F_Leaderboard__c> scope = new List<F_Leaderboard__c>();
            F_Leaderboard__c oxl = new F_Leaderboard__c();
            oxl.F_User__c = u2.Id;
            oxl.F_ChatterGroupId__c = groupId;
            oxl.EndDate__c = Date.today().addDays(1);
            oxl.StartDate__c = Date.today().addDays(-2);
            oxl.Member__c = member.Id;
            oxl.Type__c = 'Month';
            oxl.Points__c = 20;
            oxl.Position__c = 1;
            oxl.F_Type__c = 'Community';
            scope.add(oxl);
            
            F_Leaderboard__c oxl2 = new F_Leaderboard__c();
            oxl2.F_User__c = u2.Id;
            oxl2.F_ChatterGroupId__c = groupId2;
            oxl2.EndDate__c = Date.today().addDays(1);
            oxl2.StartDate__c = Date.today().addDays(-2);
            oxl2.Member__c = member2.Id;
            oxl2.Type__c = 'Month';
            oxl2.Points__c = 20;
            oxl2.Position__c = 1;
            oxl2.F_Type__c = 'Community';
            scope.add(oxl2);
            
            insert scope;
            
        }
    }
    
    @isTest
    static void test(){
        user sysAdmin = [select id, userroleid from user where profile.name = 'System Administrator' limit 1];
        
        permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdminClone'];
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :sysAdmin.Id 
                                             AND PermissionSetId = :ps3.Id];
        if(psa.size() == 0){
            insert new PermissionSetAssignment(AssigneeId = sysAdmin.id, PermissionSetId = ps3.Id);
        }  
        
        List<String> listTest = new List<String>();
        
        String groupId = [SELECT Id FROM CollaborationGroup WHERE Name = 'Test_LBoardList' LIMIT 1].Id;
        F_Leaderboard__c ox = [SELECT Id, StartDate__c, Type__c FROM F_Leaderboard__c WHERE F_ChatterGroupId__c =: groupId LIMIT 1];
        String strg = groupId+'@'+ox.Type__c+'@'+ox.StartDate__c;
        listTest.add(strg);
        
        
        String groupId2 = [SELECT Id FROM CollaborationGroup WHERE Name = 'Test_LBoardList2' LIMIT 1].Id;
        F_Leaderboard__c ox2 = [SELECT Id, StartDate__c, Type__c FROM F_Leaderboard__c WHERE F_ChatterGroupId__c =: groupId2  LIMIT 1];
        String strg2 = groupId2+'@'+ox2.Type__c+'@'+ox2.StartDate__c;
        listTest.add(strg2);
        System.debug('listTest: '+listTest);
        List<F_Leaderboard__c> sco = [SELECT id, F_User__c, F_ChatterGroupId__c, EndDate__c,Member__c, Points__c, Position__c,
                                          StartDate__c, Type__c FROM F_Leaderboard__c LIMIT 3];
        
        system.runAs(sysAdmin){
            
            Test.startTest(); 
            F_LeaderboardOrderBatch lob = new F_LeaderboardOrderBatch(0,listTest);
            Id batchId = Database.executeBatch(lob);
            Test.stopTest();
        }
    }
    
}