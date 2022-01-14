@isTest
public class F_FollowBatchTest {
    @testSetup
    private static void setup(){  
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        user sysAdmin = [select id, userroleid from user where profile.name = 'System Administrator' LIMIT 1];
        sysAdmin.CX_Role__c = 'Other';
        update sysAdmin;

		permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :sysAdmin.Id 
                                             AND PermissionSetId = :ps3.Id];
        if(psa.size() == 0){
			insert new PermissionSetAssignment(AssigneeId = sysAdmin.id, PermissionSetId = ps3.Id);
        }        
        
        sysAdmin.userroleid = testRole.Id;
        update sysAdmin;
        system.runAs(sysAdmin){
             List <Network> testnetworkList = [SELECT Id, Name FROM Network WHERE Name='FieloOrgCisco'];
			Id networkId = testnetworkList[0].Id;
            profile testProfile = [select id from profile where name = 'system administrator'];
            Account a = new Account(Name='Test Account Name');
            insert a;
            Account a2 = new Account(name = 'test account name2');
            insert a2;
            //user newUser = [select id, name from user where profile.name = 'P & C Community Profile']
            contact testContact = F_SObjectForTest.getContact();
            testContact.AccountId = a.id;
            insert testContact;
            contact testContact2 = F_SObjectForTest.getContact();
            testContact2.AccountId = a2.id;
            insert testContact2;
            //user testUser = F_SObjectForTest.getUser(testProfile.id, 'f');
            user testUser2nd = F_SobjectForTest.getUser(testProfile.id, 'a');
            testUser2nd.username = 'nome2@fielo.com';
            testUser2nd.Email = 'standarduser@fielo.com';
            System.debug('testUser2nd: ' + testUser2nd);
            //insert testUser;
            insert testUser2nd;
            FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
            insert program;
        	system.debug(testContact);
            system.debug(testcontact2);
            FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
            trig.SetupOwnerId = userInfo.getUserId();
            trig.FieloPLT__Member__c = false;
            insert trig;
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, sysAdmin.id, testContact.Id);
            member.Group_ID__c = 'test';
        	member.Group_Name__c = 'test';
            insert member;
            
            FieloPLT__Transaction__c transac = F_SObjectForTest.getTransaction(member.Id);
            insert transac;
            
            FieloPLT__Promotion__c promotion = F_SObjectForTest.getPromotion(program.Id);
            insert promotion;
            
            FieloPLT__RuleTrigger__c ruleTrigger = F_SObjectForTest.getRuleTrigger();
            insert ruleTrigger;            
            
            FieloPLT__Action__c action = F_SObjectForTest.getAction(ruleTrigger.Id);
            insert action;
            
            topic topictest = new topic();
            topictest.name ='lol';
            
            insert topictest;
			System.debug('id topic: '+topictest);
            FieloPLT__Rule__c rule = F_SObjectForTest.getRule('TestRule', promotion.Id, action.Id);
            insert rule;
            
            FieloPLT__Point__c pt = F_SObjectForTest.getPoint(member.Id, rule.Id, transac.Id);
            insert pt;         
            EntitySubscription es1 = new EntitySubscription(parentId=testUser2nd.id, subscriberID =sysAdmin.id);
            EntitySubscription es2 = new EntitySubscription(parentId=topictest.id, subscriberID =sysAdmin.id);
            insert es1;
            insert es2;
            
            List <CollaborationGroup> testGroups = new List <CollaborationGroup>();
            for (Integer i = 0; i < 1; i++){
                CollaborationGroup colGroup = new CollaborationGroup(
                    Name = 'Other',
                    CollaborationType = 'Public',
                    CanHaveGuests = false,
                    NetworkId = networkId);
                testGroups.add(colGroup);
            }

			insert testGroups;
            
            List <Id> groupIds = new List <Id>();
            for(Integer i = 0; i < 1; i++){
                for (CollaborationGroup grp : [SELECT Id FROM CollaborationGroup WHERE Name = 'Other']){
                    groupIds.add(grp.Id);
                }
                
                CollaborationGroupMember colGrMember = new CollaborationGroupMember(CollaborationGroupId = groupIds[0], MemberId = testUser2nd.Id);
                insert colGrMember;
                
            }
            
            Chatter_Event__c event = FieloSObjectFactory.createEvent(member.Id, groupIds[0], 'Follow a topic', 'Test', userInfo.getUserId());
            system.debug('event: ' + event);
            
            List<Chatter_Event__c> eventlist = new List<Chatter_Event__c>();
            eventlist.add(event);
        	system.debug('eventList test: ' + eventlist);
            
        }
    }
    
    @isTest
    static void testFollowBatch() {
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        user sysAdmin = [select id, userroleid from user where profile.name = 'System Administrator' limit 1];
		sysAdmin.userroleid = testRole.Id;
        update sysAdmin;
        
        permissionset ps3 = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :sysAdmin.Id 
                                             AND PermissionSetId = :ps3.Id];
        if(psa.size() == 0){
			insert new PermissionSetAssignment(AssigneeId = sysAdmin.id, PermissionSetId = ps3.Id);
        }  
		
        List<User> userList = [select Id,CX_Role__c from User where Email='standarduser@fielo.com'];
        userList[0].CX_Role__c ='Other';
        update userList;
        
        system.runAs(sysAdmin){
            FieloPLT__Member__c member = [select id from FieloPLT__Member__c limit 1];
            String groupId = [SELECT Id FROM CollaborationGroup WHERE Name = 'Other' LIMIT 1].Id;
            Chatter_Event__c event = FieloSObjectFactory.createEvent(member.Id, groupId, 'Follow a topic', 'Test', userInfo.getUserId());
            system.debug('event: ' + event);
            String CRON_EXP = '0 0 23 * * ?';
            F_FollowBatch b0 = new F_FollowBatch();
            Test.startTest();
            String job0 = System.schedule('ScheduledApexTest', CRON_EXP, b0);
            Test.stopTest();
            
        }
    }
}