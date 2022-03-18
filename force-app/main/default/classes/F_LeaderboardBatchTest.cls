@isTest
private class F_LeaderboardBatchTest {
    @testSetup
    static void setup(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        user sysAdmin = [select id, userroleid from user where profile.name = 'System Administrator' limit 1];
        sysAdmin.userroleid = testRole.Id;
        update sysAdmin;
        
        permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdminClone'];
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :sysAdmin.Id 
                                             AND PermissionSetId = :ps3.Id];
        if(psa.size() == 0){
            insert new PermissionSetAssignment(AssigneeId = sysAdmin.id, PermissionSetId = ps3.Id);
        }  
        
        system.runAs(sysAdmin){
            
            Recordtype recordtype = [Select ID from Recordtype where DeveloperName ='Contact' LIMIT 1];
            
            Profile prof = F_SObjectForTest.getProfile('system administrator');
            User u = F_SObjectForTest.getUser(prof.Id);
            insert u;
            
            FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
            insert program;
            
            Id groupId = FieloSObjectFactory.createTestGroup('Test' + String.valueOf(Datetime.now()));
            
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member1', program.Id, u.Id);
            member.Group_ID__c = groupId;
            insert member;
            
            FieloPLT__Member__c member2 = F_SObjectForTest.getMember('Test Member2', program.Id, u.Id);
            member2.Group_ID__c = groupId;
            
            FieloPLT__Member__c member3 = F_SObjectForTest.getMember('Test Member3', program.Id, u.Id);
            member3.Group_ID__c = groupId;
            
            FieloPLT__Member__c member4 = F_SObjectForTest.getMember('Test Member4', program.Id, u.Id);
            member4.Group_ID__c = groupId;
            
            FieloPLT__Member__c member5 = F_SObjectForTest.getMember('Test Member5', program.Id, u.Id);
            member5.Group_ID__c = groupId;
            
            FieloPLT__Member__c member6 = F_SObjectForTest.getMember('Test Member6', program.Id, u.Id);
            member6.Group_ID__c = groupId;
            
            FieloPLT__Member__c member7 = F_SObjectForTest.getMember('Test Member7', program.Id, u.Id);
            member7.Group_ID__c = groupId;
            
            FieloPLT__Member__c member8 = F_SObjectForTest.getMember('Test Member8', program.Id, u.Id);
            member8.Group_ID__c = groupId;
            
            FieloPLT__Member__c member9 = F_SObjectForTest.getMember('Test Member9', program.Id, u.Id);
            member9.Group_ID__c = groupId;
            
            FieloPLT__Member__c member10 = F_SObjectForTest.getMember('Test Member10', program.Id, u.Id);
            member10.Group_ID__c = groupId;
            
            FieloPLT__Member__c member11 = F_SObjectForTest.getMember('Test Member11', program.Id, u.Id);
            member11.Group_ID__c = groupId;
            
            FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
            trig.SetupOwnerId = userInfo.getUserId();
            trig.FieloPLT__Member__c = false;
            insert trig;
            
            insert member2;
            insert member3;
            insert member4;
            insert member5;
            insert member6;
            insert member7;
            insert member8;
            insert member9;
            insert member10;
            insert member11;
            
            List<FieloPLT__Transaction__c> scope = new List<FieloPLT__Transaction__c>();
            /*
            Chatter_Event__c event = FieloSObjectFactory.createEvent(member.Id, groupId, 'Answer a question', 'Test');
            insert event;
            FieloPLT__Transaction__c transac =  F_SObjectForTest.getTransaction(member.Id);
            transac.FieloPLT__Member__c = member.id;
            transac.FieloPLT__Date__c = System.now().addDays(-1);
            transac.FieloPLT__IsProcessed__c = true;
            transac.Chatter_Event__c = event.Id;
            scope.add(transac);*/
            
            Chatter_Event__c event2 = FieloSObjectFactory.createEvent(member2.Id, groupId, 'Your answer is marked as best', 'Test');
            insert event2;
            FieloPLT__Transaction__c transac2 =  F_SObjectForTest.getTransaction(member2.Id);
            transac2.FieloPLT__Member__c = member2.id;
            transac2.FieloPLT__Date__c = System.now().addDays(-1);
            transac2.FieloPLT__IsProcessed__c = true;
            transac2.Chatter_Event__c = event2.id;
            scope.add(transac2);
            
            Chatter_Event__c event3 = FieloSObjectFactory.createEvent(member10.Id, groupId, 'Receive a like', 'Test');
            //insert event3;
            FieloPLT__Transaction__c transac3 =  F_SObjectForTest.getTransaction(member10.Id);
            transac3.FieloPLT__Member__c = member10.id;
            transac3.FieloPLT__Date__c = System.now().addDays(-1);
            transac3.FieloPLT__IsProcessed__c = true;
            //transac3.Chatter_Event__c = event3.id;
            scope.add(transac3);
            
            Chatter_Event__c event4 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Write a post', 'Test');
            insert event4;
            FieloPLT__Transaction__c transac4 =  F_SObjectForTest.getTransaction(member3.Id);
            transac4.FieloPLT__Member__c = member3.id;
            transac4.FieloPLT__Date__c = System.now().addDays(-1);
            transac4.FieloPLT__IsProcessed__c = true;
            transac4.Chatter_Event__c = event4.id;
            scope.add(transac4);
            
            Chatter_Event__c event5 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Receive a like', 'Test');
            insert event5;
            FieloPLT__Transaction__c transac5 =  F_SObjectForTest.getTransaction(member3.Id);
            transac5.FieloPLT__Member__c = member3.id;
            transac5.FieloPLT__Date__c = System.now().addDays(-1);
            transac5.FieloPLT__IsProcessed__c = true;
            transac5.Chatter_Event__c = event5.id;
            scope.add(transac5);
            /*
            Chatter_Event__c event6 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Follow a person', 'Test');
            insert event6;
            FieloPLT__Transaction__c transac6 =  F_SObjectForTest.getTransaction(member3.Id);
            transac6.FieloPLT__Member__c = member3.id;
            transac6.FieloPLT__Date__c = System.now().addDays(-1);
            transac6.FieloPLT__IsProcessed__c = true;
            transac6.Chatter_Event__c = event6.id;
            scope.add(transac6);
            
            Chatter_Event__c event7 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Submit an idea', 'Test');
            insert event7;
            FieloPLT__Transaction__c transac7 =  F_SObjectForTest.getTransaction(member3.Id);
            transac7.FieloPLT__Member__c = member3.id;
            transac7.FieloPLT__Date__c = System.now().addDays(-1);
            transac7.FieloPLT__IsProcessed__c = true;
            transac7.Chatter_Event__c = event7.id;
            scope.add(transac7);
            
            Chatter_Event__c event8 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Like something', 'Test');
            insert event8;
            FieloPLT__Transaction__c transac8 =  F_SObjectForTest.getTransaction(member3.Id);
            transac8.FieloPLT__Member__c = member3.id;
            transac8.FieloPLT__Date__c = System.now().addDays(-1);
            transac8.FieloPLT__IsProcessed__c = true;
            transac8.Chatter_Event__c = event8.id;
            scope.add(transac8);
            
            Chatter_Event__c event9 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Answer a question', 'Test');
            insert event9;
            FieloPLT__Transaction__c transac9 =  F_SObjectForTest.getTransaction(member3.Id);
            transac9.FieloPLT__Member__c = member3.id;
            transac9.FieloPLT__Date__c = System.now().addDays(-1);
            transac9.FieloPLT__IsProcessed__c = true;
            transac9.Chatter_Event__c = event9.Id;
            scope.add(transac9);*/
            
            Chatter_Event__c event10 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Your answer is marked as best', 'Test');
            insert event10;
            FieloPLT__Transaction__c transac10 =  F_SObjectForTest.getTransaction(member3.Id);
            transac10.FieloPLT__Member__c = member3.id;
            transac10.FieloPLT__Date__c = System.now().addDays(-1);
            transac10.FieloPLT__IsProcessed__c = true;
            transac10.Chatter_Event__c = event10.id;
            scope.add(transac10);
            
            Chatter_Event__c event11 = FieloSObjectFactory.createEvent(member11.Id, groupId, 'Receive a like', 'Test');
            insert event11;
            FieloPLT__Transaction__c transac11 =  F_SObjectForTest.getTransaction(member11.Id);
            transac11.FieloPLT__Member__c = member11.id;
            transac11.FieloPLT__Date__c = System.now().addDays(-1);
            transac11.FieloPLT__IsProcessed__c = true;
            transac11.Chatter_Event__c = event11.id;
            scope.add(transac11);
            /*
            Chatter_Event__c event12 = FieloSObjectFactory.createEvent(member8.Id, groupId, 'Follow a person', 'Test');
            insert event12;
            FieloPLT__Transaction__c transac12 =  F_SObjectForTest.getTransaction(member8.Id);
            transac12.FieloPLT__Member__c = member8.id;
            transac12.FieloPLT__Date__c = System.now().addDays(-1);
            transac12.FieloPLT__IsProcessed__c = true;
            transac12.Chatter_Event__c = event12.id;
            scope.add(transac12);*/
            
            Chatter_Event__c event13 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Write a post', 'Test');
            insert event13;
            FieloPLT__Transaction__c transac13 =  F_SObjectForTest.getTransaction(member3.Id);
            transac13.FieloPLT__Member__c = member3.id;
            transac13.FieloPLT__Date__c = System.now().addDays(-1);
            transac13.FieloPLT__IsProcessed__c = true;
            transac13.Chatter_Event__c = event13.id;
            scope.add(transac13);
            /*
            Chatter_Event__c event14 = FieloSObjectFactory.createEvent(member3.Id, groupId, 'Share a post', 'Test');
            insert event14;
            FieloPLT__Transaction__c transac14 =  F_SObjectForTest.getTransaction(member3.Id);
            transac14.FieloPLT__Member__c = member3.id;
            transac14.FieloPLT__Date__c = System.now().addDays(-1);
            transac14.FieloPLT__IsProcessed__c = true;
            transac14.Chatter_Event__c = event14.id;
            scope.add(transac14);
            
            Chatter_Event__c event15 = FieloSObjectFactory.createEvent(member2.Id, groupId, 'Ask a question', 'Test');
            insert event15;
            FieloPLT__Transaction__c transac15 =  F_SObjectForTest.getTransaction(member2.Id);
            transac15.FieloPLT__Member__c = member2.id;
            transac15.FieloPLT__Date__c = System.now().addDays(-1);
            transac15.FieloPLT__IsProcessed__c = true;
            transac15.Chatter_Event__c = event15.id;
            scope.add(transac15);*/
            
            Chatter_Event__c event16 = FieloSObjectFactory.createEvent(member.Id, groupId, 'Receive a like', 'Test');
            insert event16;
            FieloPLT__Transaction__c transac16 =  F_SObjectForTest.getTransaction(member.Id);
            transac16.FieloPLT__Member__c = member.id;
            transac16.FieloPLT__Date__c = System.now().addDays(-1);
            transac16.FieloPLT__IsProcessed__c = true;
            transac16.Chatter_Event__c = event16.id;
            scope.add(transac16);
            /*
            Chatter_Event__c event17 = FieloSObjectFactory.createEvent(member6.Id, groupId, 'Follow a topic', 'Test');
            insert event17;
            FieloPLT__Transaction__c transac17 =  F_SObjectForTest.getTransaction(member6.Id);
            transac17.FieloPLT__Member__c = member6.id;
            transac17.FieloPLT__Date__c = System.now().addDays(-1);
            transac17.FieloPLT__IsProcessed__c = true;
            transac17.Chatter_Event__c = event17.id;
            scope.add(transac17);*/
            
            Chatter_Event__c event18 = FieloSObjectFactory.createEvent(member7.Id, groupId, 'Receive a like', 'Test');
            insert event18;
            FieloPLT__Transaction__c transac18 =  F_SObjectForTest.getTransaction(member7.Id);
            transac18.FieloPLT__Member__c = member7.id;
            transac18.FieloPLT__Date__c = System.now().addDays(-1);
            transac18.FieloPLT__IsProcessed__c = true;
            transac18.Chatter_Event__c = event18.id;
            scope.add(transac18);
            /*
            Chatter_Event__c event19 = FieloSObjectFactory.createEvent(member9.Id, groupId, 'Mark an answer as best', 'Test');
            insert event19;
            FieloPLT__Transaction__c transac19 =  F_SObjectForTest.getTransaction(member9.Id);
            transac19.FieloPLT__Member__c = member9.id;
            transac19.FieloPLT__Date__c = System.now().addDays(-1);
            transac19.FieloPLT__IsProcessed__c = true;
            transac19.Chatter_Event__c = event19.id;
            scope.add(transac19);
            
            Chatter_Event__c event20 = FieloSObjectFactory.createEvent(member10.Id, groupId, 'Mention someone', 'Test');
            insert event20;
            FieloPLT__Transaction__c transac20 =  F_SObjectForTest.getTransaction(member10.Id);
            transac20.FieloPLT__Member__c = member10.id;
            transac20.FieloPLT__Date__c = System.now().addDays(-1);
            transac20.FieloPLT__IsProcessed__c = true;
            transac20.Chatter_Event__c = event20.id;
            scope.add(transac20);*/
            
            Chatter_Event__c event21 = FieloSObjectFactory.createEvent(member4.Id, groupId, 'Write a post', 'Test');
            insert event21;
            FieloPLT__Transaction__c transac21 =  F_SObjectForTest.getTransaction(member4.Id);
            transac21.FieloPLT__Member__c = member4.id;
            transac21.FieloPLT__Date__c = System.now().addDays(-1);
            transac21.FieloPLT__IsProcessed__c = true;
            transac21.Chatter_Event__c = event21.id;
            scope.add(transac21);
            
            Chatter_Event__c event22 = FieloSObjectFactory.createEvent(member5.Id, groupId, 'Receive a like', 'Test');
            insert event22;
            FieloPLT__Transaction__c transac22 =  F_SObjectForTest.getTransaction(member5.Id);
            transac22.FieloPLT__Member__c = member5.id;
            transac22.FieloPLT__Date__c = System.now().addDays(-1);
            transac22.FieloPLT__IsProcessed__c = true;
            transac22.Chatter_Event__c = event22.id;
            scope.add(transac22);
            /*
            Chatter_Event__c event23 = FieloSObjectFactory.createEvent(member6.Id, groupId, 'Follow a person', 'Test');
            insert event23;
            FieloPLT__Transaction__c transac23 =  F_SObjectForTest.getTransaction(member6.Id);
            transac23.FieloPLT__Member__c = member6.id;
            transac23.FieloPLT__Date__c = System.now().addDays(-1);
            transac23.FieloPLT__IsProcessed__c = true;
            transac23.Chatter_Event__c = event23.id;
            scope.add(transac23);
            
            Chatter_Event__c event24 = FieloSObjectFactory.createEvent(member7.Id, groupId, 'Submit an idea', 'Test');
            insert event24;
            FieloPLT__Transaction__c transac24 =  F_SObjectForTest.getTransaction(member7.Id);
            transac24.FieloPLT__Member__c = member7.id;
            transac24.FieloPLT__Date__c = System.now().addDays(-1);
            transac24.FieloPLT__IsProcessed__c = true;
            transac24.Chatter_Event__c = event24.id;
            scope.add(transac24);
            
            Chatter_Event__c event25 = FieloSObjectFactory.createEvent(member8.Id, groupId, 'Like something', 'Test');
            insert event25;
            FieloPLT__Transaction__c transac25 =  F_SObjectForTest.getTransaction(member8.Id);
            transac25.FieloPLT__Member__c = member8.id;
            transac25.FieloPLT__Date__c = System.now().addDays(-1);
            transac25.FieloPLT__IsProcessed__c = true;
            transac25.Chatter_Event__c = event25.id;
            scope.add(transac25);
            
            Chatter_Event__c event26 = FieloSObjectFactory.createEvent(member10.Id, groupId, 'Answer a question', 'Test');
            insert event26;
            FieloPLT__Transaction__c transac26 =  F_SObjectForTest.getTransaction(member10.Id);
            transac26.FieloPLT__Member__c = member10.id;
            transac26.FieloPLT__Date__c = System.now().addDays(-1);
            transac26.FieloPLT__IsProcessed__c = true;
            transac26.Chatter_Event__c = event26.Id;
            scope.add(transac26);*/
            
            Chatter_Event__c event27 = FieloSObjectFactory.createEvent(member9.Id, groupId, 'Your answer is marked as best', 'Test');
            insert event27;
            FieloPLT__Transaction__c transac27 =  F_SObjectForTest.getTransaction(member9.Id);
            transac27.FieloPLT__Member__c = member9.id;
            transac27.FieloPLT__Date__c = System.now().addDays(-1);
            transac27.FieloPLT__IsProcessed__c = true;
            transac27.Chatter_Event__c = event27.id;
            scope.add(transac27);
            
            Chatter_Event__c event28 = FieloSObjectFactory.createEvent(member8.Id, groupId, 'Receive a like', 'Test');
            insert event28;
            FieloPLT__Transaction__c transac28 =  F_SObjectForTest.getTransaction(member8.Id);
            transac28.FieloPLT__Member__c = member8.id;
            transac28.FieloPLT__Date__c = System.now().addDays(-1);
            transac28.FieloPLT__IsProcessed__c = true;
            transac28.Chatter_Event__c = event28.id;
            scope.add(transac28);
            /*
            Chatter_Event__c event29 = FieloSObjectFactory.createEvent(member10.Id, groupId, 'Follow a person', 'Test');
            insert event29;
            FieloPLT__Transaction__c transac29 =  F_SObjectForTest.getTransaction(member10.Id);
            transac29.FieloPLT__Member__c = member10.id;
            transac29.FieloPLT__Date__c = System.now().addDays(-1);
            transac29.FieloPLT__IsProcessed__c = true;
            transac29.Chatter_Event__c = event29.id;
            scope.add(transac29);*/
            
            Chatter_Event__c event30 = FieloSObjectFactory.createEvent(member9.Id, groupId, 'Write a post', 'Test');
            insert event30;
            FieloPLT__Transaction__c transac30 =  F_SObjectForTest.getTransaction(member9.Id);
            transac30.FieloPLT__Member__c = member9.id;
            transac30.FieloPLT__Date__c = System.now().addDays(-1);
            transac30.FieloPLT__IsProcessed__c = true;
            transac30.Chatter_Event__c = event30.id;
            transac30.FieloPLT__Points__c = 4;
            scope.add(transac30);
            /*
            Chatter_Event__c event31 = FieloSObjectFactory.createEvent(member10.Id, groupId, 'Follow a topic', 'Test');
            insert event31;
            FieloPLT__Transaction__c transac31 =  F_SObjectForTest.getTransaction(member10.Id);
            transac31.FieloPLT__Member__c = member10.id;
            transac31.FieloPLT__Date__c = System.now().addDays(-1);
            transac31.FieloPLT__IsProcessed__c = true;
            transac31.Chatter_Event__c = event31.id;
            scope.add(transac31);
            
            Chatter_Event__c event32 = FieloSObjectFactory.createEvent(member11.Id, groupId, 'Mark an answer as best', 'Test');
            insert event32;
            FieloPLT__Transaction__c transac32 =  F_SObjectForTest.getTransaction(member11.Id);
            transac32.FieloPLT__Member__c = member11.id;
            transac32.FieloPLT__Date__c = System.now().addDays(-1);
            transac32.FieloPLT__IsProcessed__c = true;
            transac32.Chatter_Event__c = event32.id;
            scope.add(transac32);*/
            
            Chatter_Event__c event33 = FieloSObjectFactory.createEvent(member11.Id, groupId, 'Receive a like', 'Test');
            insert event33;
            FieloPLT__Transaction__c transac33 =  F_SObjectForTest.getTransaction(member11.Id);
            transac33.FieloPLT__Member__c = member11.id;
            transac33.FieloPLT__Date__c = System.now().addDays(-1);
            transac33.FieloPLT__IsProcessed__c = true;
            transac33.Chatter_Event__c = event33.id;
            transac33.FieloPLT__Points__c = 4;
            scope.add(transac33);
            
            Chatter_Event__c event34 = FieloSObjectFactory.createEvent(member11.Id, groupId, 'Write a post', 'Test');
            insert event34;
            FieloPLT__Transaction__c transac34 =  F_SObjectForTest.getTransaction(member11.Id);
            transac34.FieloPLT__Member__c = member11.id;
            transac34.FieloPLT__Date__c = System.now().addDays(-1);
            transac34.FieloPLT__IsProcessed__c = true;
            transac34.Chatter_Event__c = event34.id;
            transac34.FieloPLT__Points__c = 4;
            scope.add(transac34);
            
            insert scope;
            
            List<FieloPLT__Transaction__c> aaa = [SELECT Id, FieloPLT__Member__c, FieloPLT__Member__r.FieloPLT__User__c, Chatter_Event__c,
                                          Chatter_Event__r.type__c, FieloPLT__Member__r.Group_ID__c, FieloPLT__Points__c 
                                          FROM FieloPLT__Transaction__c WHERE FieloPLT__Date__c = YESTERDAY AND FieloPLT__IsProcessed__c = true];
            system.debug('aaaaa'+ transac34);
            System.debug('scope setup: '+scope);
            FieloPLT__Promotion__c promotion = F_SObjectForTest.getPromotion(program.Id);
            insert promotion;
            
            FieloPLT__RuleTrigger__c ruleTrigger = F_SObjectForTest.getRuleTrigger();
            insert ruleTrigger;
            
            FieloPLT__Action__c action = F_SObjectForTest.getAction(ruleTrigger.Id);
            insert action;
            
            FieloPLT__Rule__c rule = F_SObjectForTest.getRule('TestRule', promotion.Id, action.Id);
            insert rule;
            
            List<F_Leaderboard__c> oxlList = new List<F_Leaderboard__c>();
			
            F_Leaderboard__c oxl3 = new F_Leaderboard__c();
            oxl3.F_User__c = member3.FieloPLT__User__c;
            oxl3.F_ChatterGroupId__c = groupId;
            oxl3.EndDate__c = Date.today().addDays(1);
            oxl3.StartDate__c = Date.newInstance(2022, 01, 01);
            oxl3.Member__c = member3.Id;
            oxl3.Type__c = 'Quarter';
            oxl3.Points__c = 100;
            oxl3.Position__c = 3;
            oxl3.F_Type__c = 'Community';
            oxl3.Number_Answers__c = 4;
            oxl3.Number_Best_Answers__c = 3;
            oxl3.Number_Blogs__c = 8;
            oxl3.Number_Comments__c = 2;
            oxl3.Number_Comments_Rece__c = 4;
            oxl3.Number_Followers__c = 12;
            oxl3.Number_Ideas__c = 1;
            oxl3.Number_Likes_given__c = 5;
            
            oxl3.Number_Likes_received__c = 2;
            oxl3.Number_Marking_Answers_as_best__c = 1;
            oxl3.Number_Mentions_given__c = 3;
            oxl3.Number_Mentions_received__c = 4;
            oxl3.Number_Person_followed__c = 20;
            oxl3.Number_Posts__c = 4;
            oxl3.Number_Posts_Shared__c = 14;
            oxl3.Number_Questions__c = 1;
            oxl3.Number_Questions_answered__c = 3;
            oxl3.Number_Topics_Followed__c = 2;
            
            oxlList.add(oxl3);
            
            system.debug('oxl3: '+oxl3);
            
            insert oxlList;
            
            F_LeaderboardBatch cb = New F_LeaderboardBatch();

            Database.QueryLocator ql = cb.start(null);
            cb.execute(null,scope);
            cb.Finish(null);
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
        
        system.runAs(sysAdmin){
            String CRON_EXP = '0 0 23 * * ?';
            Test.startTest();
            F_LeaderboardBatch lb = new F_LeaderboardBatch();
            String jobId = System.schedule('ScheduledApexTest', CRON_EXP, lb);
            Test.stopTest();
        }
        
    }
}