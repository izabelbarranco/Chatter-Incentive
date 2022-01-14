@isTest(SeeAllData=true)
public class F_FeedLikesBatch_Test {
    
    @istest(SeeAllData=true)
    public static void F_FeedLikesBatch_Test() {
        FieloPLT.CacheAPI.enableCacheAccess(false);
        
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        adminUser.userRoleId = testRole.id;
        
        update adminUser;
        
        permissionset ps = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        insert new PermissionSetAssignment(AssigneeId = adminUser.id, PermissionSetId = ps.Id);
        
        system.runAs(adminUser){
            FieloPLT__Program__c program = [SELECT Id, Name FROM FieloPLT__Program__c LIMIT 1];
            
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, UserInfo.getUserId());
            
            FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
            trig.SetupOwnerId = userInfo.getUserId();
            trig.FieloPLT__Member__c = false;
            insert trig;
            system.debug('trig '+FIELOPLT__Triggers__c.getInstance(UserInfo.getUserId()).FieloPLT__Member__c);
            insert member;
            
            
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            textSegmentInput.text = 'Does anyone know anyone with contacts here?';
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            
            // Use a record ID for the subject ID.
            feedItemInput.subjectId = getCommunityUserId();
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement([SELECT NetworkId FROM NetworkMember WHERE Network.Name = 'FieloOrgCisco' limit 1][0].NetworkId, feedItemInput);
            String feedElementId = feedElement.id;
            
            ConnectApi.ChatterLike chatterLike = ConnectApi.ChatterFeeds.likeFeedElement([SELECT NetworkId FROM NetworkMember WHERE Network.Name = 'FieloOrgCisco' limit 1][0].NetworkId, feedElementId);    
            
            test.startTest();
            F_FeedLikesBatch test1 = New F_FeedLikesBatch();
            database.executeBatch(test1);
            test.stopTest();
        }
    }
    
    @istest(SeeAllData=true)
    static void test() {
        FieloPLT.CacheAPI.enableCacheAccess(false);
        
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        
        system.runAs(adminUser){
            FieloPLT__Program__c program = [SELECT Id, Name FROM FieloPLT__Program__c LIMIT 1];
            
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, UserInfo.getUserId());
            
            FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
            trig.SetupOwnerId = userInfo.getUserId();
            trig.FieloPLT__Member__c = false;
            insert trig;
            system.debug('trig '+FIELOPLT__Triggers__c.getInstance(UserInfo.getUserId()).FieloPLT__Member__c);
            insert member;
            
            FieloPLT.CacheAPI.enableCacheAccess(false);
            
            String CRON_EXP = '0 0 23 * * ?';
            F_FeedLikesBatch b0 = new F_FeedLikesBatch();
            Test.startTest();
            String job0 = System.schedule('ScheduledApexTest', CRON_EXP, b0);
            Test.stopTest();
        }
    }
    
    private static Id getCommunityUserId(){
        
        return [SELECT network.name, networkId, memberID FROM NetworkMember WHERE Network.Name = 'FieloOrgCisco' LIMIT 1].MemberId;  
    }
}