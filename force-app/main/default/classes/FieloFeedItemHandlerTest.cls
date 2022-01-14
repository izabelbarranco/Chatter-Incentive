@isTest
private class FieloFeedItemHandlerTest {
    
    @isTest(seeAllData=true)
    static void testOnAfterInsert(){
        FieloPLT.CacheAPI.enableCacheAccess(false);
        List <Network> testnetworkList = [SELECT Id, Name FROM Network WHERE Name='FieloOrgCisco'];
		Id networkId = testnetworkList[0].Id;
        
        Profile prof = F_SObjectForTest.getProfile('system administrator');
        User u = F_SObjectForTest.getUser(prof.Id);
        insert u;
        
        FieloPLT__Program__c program = [SELECT Id, Name FROM FieloPLT__Program__c LIMIT 1];
        
        FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, u.Id);
        member.Group_ID__c = 'test';
        member.Group_Name__c = 'test';
        
        FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
        trig.SetupOwnerId = userInfo.getUserId();
        trig.FieloPLT__Member__c = false;
        insert trig;
        system.debug('trig '+FIELOPLT__Triggers__c.getInstance(UserInfo.getUserId()).FieloPLT__Member__c);
        insert member;
        
		member = [SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c WHERE Group_ID__c != '' AND FieloPLT__User__c != null LIMIT 1];


        System.runAs(u){       
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            textSegmentInput.text = 'Does anyone know anyone with contacts here?';
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            // Mention a group.
            mentionSegmentInput.id = u.Id;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            
            // Use a record ID for the subject ID.
            feedItemInput.subjectId = u.Id;
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement([SELECT NetworkId FROM NetworkMember WHERE Network.Name = 'FieloOrgCisco' limit 1][0].NetworkId, feedItemInput);
        
        }
     
    }
}