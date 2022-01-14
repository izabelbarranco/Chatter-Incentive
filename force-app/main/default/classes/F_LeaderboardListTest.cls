@isTest
private class F_LeaderboardListTest {
    
    @testSetup
    static void setup(){
        
        user u = [select id, userroleid from user where profile.name = 'Fielo Essentials Admin' LIMIT 1];
        
        permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
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
            
            User u3 = F_SObjectForTest.getUser(prof.Id);
            u3.username = 'testc1@fielo.com';
            u3.CommunityNickname = 'vnc2';
            insert u3;
            
            User u4 = F_SObjectForTest.getUser(prof.Id);
            u4.username = 'testc2@fielo.com';
            u4.CommunityNickname = 'vnc3';
            insert u4;
            
            FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
            insert program;
            
            FieloPLT__Program__c program2 = F_SObjectForTest.getProgram('Test Program2');
            insert program2;
            
            FieloPLT__Program__c program3 = F_SObjectForTest.getProgram('Test Program3');
            insert program3;
            
            FieloPLT__Program__c program4 = F_SObjectForTest.getProgram('Test Program3');
            insert program4;
            
            
            Id groupId = FieloSObjectFactory.createTestGroup('Test_LBoardList');
            Id groupId2 = FieloSObjectFactory.createTestGroup('Test15');
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member1', program.Id, u.Id);
            member.Group_ID__c = groupId;
            insert member;
            
            FieloPLT__Member__c member2 = F_SObjectForTest.getMember('Test Member2', program2.Id, u3.Id);
            member2.Group_ID__c = groupId;
            insert member2;
            
            
            
            FieloPLT__Member__c member3 = F_SObjectForTest.getMember('Test Member3', program3.Id, u4.Id);
            member3.Group_ID__c = groupId2;
            insert member3;
            
            FieloPLT__Member__c member4 = F_SObjectForTest.getMember('Test Member4', program4.Id, u2.Id);
            member4.Group_ID__c = groupId;
            insert member4;
            
            
            FieloPLT__Promotion__c promotion = F_SObjectForTest.getPromotion(program.Id);
            insert promotion;
            
            FieloPLT__RuleTrigger__c ruleTrigger = F_SObjectForTest.getRuleTrigger();
            insert ruleTrigger;
            
            FieloPLT__Action__c action = F_SObjectForTest.getAction(ruleTrigger.Id);
            insert action;
            
            FieloPLT__Rule__c rule = F_SObjectForTest.getRule('TestRule', promotion.Id, action.Id);
            insert rule;
            
            F_Leaderboard__c oxl = new F_Leaderboard__c();
            oxl.F_User__c = u2.Id;
            oxl.F_ChatterGroupId__c = 'test';
            oxl.EndDate__c = Date.today().addDays(1);
            oxl.StartDate__c = Date.today().addDays(-2);
            oxl.Member__c = member2.Id;
            oxl.Type__c = 'Week';
            oxl.Points__c = 20;
            oxl.Position__c = 1;
            oxl.F_Type__c = 'Community';
            insert oxl;
            
            F_Leaderboard__c oxl2 = new F_Leaderboard__c();
            oxl2.F_User__c = u3.Id;
            oxl2.F_ChatterGroupId__c = 'test';
            oxl2.EndDate__c = Date.today().addDays(1);
            oxl2.StartDate__c = Date.today().addDays(-4);
            oxl2.Member__c = member2.Id;
            oxl2.Type__c = 'Week';
            oxl2.Points__c = 20;
            oxl2.Position__c = 2;
            oxl2.F_Type__c = 'Community';
            insert oxl2; 
            
            F_Leaderboard__c oxl3 = new F_Leaderboard__c();
            oxl3.F_User__c = u3.Id;
            oxl3.F_ChatterGroupId__c = 'test';
            oxl3.EndDate__c = Date.today().addDays(1);
            oxl3.StartDate__c = Date.today().addDays(-4);
            oxl3.Member__c = member2.Id;
            oxl3.Type__c = 'Week';
            oxl3.Points__c = 20;
            oxl3.Position__c = 3;
            oxl3.F_Type__c = 'Community';
            insert oxl3; 
            
            F_Leaderboard__c oxl4 = new F_Leaderboard__c();
            oxl4.F_User__c = u3.Id;
            oxl4.F_ChatterGroupId__c = 'test';
            oxl4.EndDate__c = Date.today().addDays(1);
            oxl4.StartDate__c = Date.today().addDays(-4);
            oxl4.Member__c = member2.Id;
            oxl4.Type__c = 'Week';
            oxl4.Points__c = 20;
            oxl4.Position__c = 4;
            oxl4.F_Type__c = 'Community';
            insert oxl4; 
            
            F_Leaderboard__c oxl5 = new F_Leaderboard__c();
            oxl5.F_User__c = u3.Id;
            oxl5.F_ChatterGroupId__c = 'test';
            oxl5.EndDate__c = Date.today().addDays(1);
            oxl5.StartDate__c = Date.today().addDays(-4);
            oxl5.Member__c = member2.Id;
            oxl5.Type__c = 'Week';
            oxl5.Points__c = 20;
            oxl5.Position__c = 5;
            oxl5.F_Type__c = 'Community';
            insert oxl5; 
            
            F_Leaderboard__c oxl6 = new F_Leaderboard__c();
            oxl6.F_User__c = u3.Id;
            oxl6.F_ChatterGroupId__c = 'test';
            oxl6.EndDate__c = Date.today().addDays(1);
            oxl6.StartDate__c = Date.today().addDays(-4);
            oxl6.Member__c = member4.Id;
            oxl6.Type__c = 'Week';
            oxl6.Points__c = 20;
            oxl6.Position__c = 6;
            oxl6.F_Type__c = 'Community';
            insert oxl6; 
            
            F_Leaderboard__c oxl7 = new F_Leaderboard__c();
            oxl7.F_User__c = u3.Id;
            oxl7.F_ChatterGroupId__c = 'test';
            oxl7.EndDate__c = Date.today().addDays(1);
            oxl7.StartDate__c = Date.today().addDays(-4);
            oxl7.Member__c = member2.Id;
            oxl7.Type__c = 'Week';
            oxl7.Points__c = 20;
            oxl7.Position__c = 7;
            oxl7.F_Type__c = 'Community';
            insert oxl7; 
            
            F_Leaderboard__c oxl8 = new F_Leaderboard__c();
            oxl8.F_User__c = u3.Id;
            oxl8.F_ChatterGroupId__c = 'test';
            oxl8.EndDate__c = Date.today().addDays(1);
            oxl8.StartDate__c = Date.today().addDays(-4);
            oxl8.Member__c = member2.Id;
            oxl8.Type__c = 'Week';
            oxl8.Points__c = 20;
            oxl8.Position__c = 8;
            oxl8.F_Type__c = 'Community';
            insert oxl8; 
            
            F_Leaderboard__c oxl9 = new F_Leaderboard__c();
            oxl9.F_User__c = u3.Id;
            oxl9.F_ChatterGroupId__c = 'test';
            oxl9.EndDate__c = Date.today().addDays(1);
            oxl9.StartDate__c = Date.today().addDays(-4);
            oxl9.Member__c = member2.Id;
            oxl9.Type__c = 'Week';
            oxl9.Points__c = 20;
            oxl9.Position__c = 9;
            oxl9.F_Type__c = 'Community';
            insert oxl9; 
            
            F_Leaderboard__c oxl10 = new F_Leaderboard__c();
            oxl10.F_User__c = u3.Id;
            oxl10.F_ChatterGroupId__c = 'test';
            oxl10.EndDate__c = Date.today().addDays(1);
            oxl10.StartDate__c = Date.today().addDays(-4);
            oxl10.Member__c = member2.Id;
            oxl10.Type__c = 'Week';
            oxl10.Points__c = 20;
            oxl10.Position__c = 10;
            oxl10.F_Type__c = 'Community';
            insert oxl10; 
            
            F_Leaderboard__c oxl11 = new F_Leaderboard__c();
            oxl11.F_User__c = u3.Id;
            oxl11.F_ChatterGroupId__c = 'test';
            oxl11.EndDate__c = Date.today().addDays(1);
            oxl11.StartDate__c = Date.today().addDays(-4);
            oxl11.Member__c = member2.Id;
            oxl11.Type__c = 'Week';
            oxl11.Points__c = 20;
            oxl11.Position__c = 11;
            oxl11.F_Type__c = 'Community';
            insert oxl11; 
            
            F_Leaderboard__c oxl12 = new F_Leaderboard__c();
            oxl12.F_User__c = u3.Id;
            oxl12.F_ChatterGroupId__c = 'test';
            oxl12.EndDate__c = Date.today().addDays(1);
            oxl12.StartDate__c = Date.today().addDays(-4);
            oxl12.Member__c = member.Id;
            oxl12.Type__c = 'Week';
            oxl12.Points__c = 20;
            oxl12.Position__c = 12;
            oxl12.F_Type__c = 'Community';
            insert oxl12; 
        }
    }
    @isTest
    private static void testGetLeaderboard(){
        user user1 = [select id, userroleid from user where profile.name = 'Fielo Essentials Admin' limit 1];
        user user2 = [select id, userroleid from user where username = 'testc2@fielo.com' limit 1];
        user user3 = [select id, userroleid from user where username = 'testc1@fielo.com' limit 1];
        user user4 = [select id, userroleid from user where username = 'testc@fielo.com' limit 1];
        permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :user1.Id 
                                             AND PermissionSetId = :ps3.Id];
        if(psa.size() == 0){
            insert new PermissionSetAssignment(AssigneeId = user1.id, PermissionSetId = ps3.Id);
        }  
        list<F_Leaderboard__c> llist = [select position__c, f_user__c from F_Leaderboard__c];
        system.debug('llist:' + llist);
        list<fieloplt__member__c> memberlist = [select id, fieloplt__user__c, group_id__c from fieloplt__member__c];
        system.debug('memberlist:' + memberlist);
        
        collaborationgroup grouptest = [select id from collaborationgroup where name = 'Test_LBoardList'];
        collaborationgroup grouptest2 = [select id from collaborationgroup where name = 'test15'];
        system.debug(grouptest.id);
        system.debug(user1.id);
        

        Test.startTest();
        system.runAs(user1){
            F_leaderboardList.getLeaderboardList('week', grouptest.Id, 5);
            F_leaderboardList.getLeaderboardList('week', grouptest.Id, 9);
            
        }
        
        system.runAs(user2){
            F_leaderboardList.getLeaderboardList('week', grouptest2.Id, 5);
        }
        
        system.runAs(user3){
            F_leaderboardList.getLeaderboardList('week', grouptest.Id, 5);
        }
        
        system.runAs(user4){
            F_leaderboardList.getLeaderboardList('week', grouptest.Id, 5);
        }
        Test.stopTest();
        
    }
    
    @isTest
    private static void testRelatedMethods(){
        user curUser = [select id from user where username = 'testc2@fielo.com'];
        collaborationgroup grouptest = [select id from collaborationgroup where name = 'test15'];
        Test.startTest();
        system.runAs(curUser){
            id curMemberID = F_leaderboardlist.getCurrentMember(grouptest.id);
            F_leaderboardlist.getPeriods();
            F_leaderboardlist.getGroups();
            F_leaderboardlist.getCurrentLevel(curMemberID);
            F_leaderboardlist.getOrder();
            f_leaderboardlist.getPointsForUser();
        }
        Test.stopTest();
    }
    

    
    @isTest
    private static void testGetFields(){
        test.startTest();
        List<String> testlist = new list<String> { 'points__c', 'Number_likes_received__c'};
        f_leaderboardlist.getFields(testlist);
        test.stopTest();
    }
    
    

}