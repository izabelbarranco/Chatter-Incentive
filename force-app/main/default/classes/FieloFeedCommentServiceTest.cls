@isTest
public class FieloFeedCommentServiceTest {		
    @IsTest(seeAllData=True)
    public static void fieloEventForumCommentTest() {
        
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;
        
        
        system.runAs(adminUser){
            
            FieloPLT.CacheAPI.enableCacheAccess(false);
            
            Profile prof = F_SObjectForTest.getProfile('system administrator');
            FieloPLT__Program__c program = [SELECT Id, Name FROM FieloPLT__Program__c LIMIT 1];
            
            FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, UserInfo.getUserId());
            FieloPLT__Member__c member2 = F_SObjectForTest.getMember('Test Member2', program.Id, UserInfo.getUserId());
            
            Test.startTest();
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            textSegmentInput.text = 'Does anyone know anyone with contacts here?';
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            // Mention a group.
            mentionSegmentInput.id = getCommunityUserId();
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            
            // Use a record ID for the subject ID.
            feedItemInput.subjectId = getCommunityUserId();
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement([SELECT NetworkId FROM NetworkMember WHERE Network.Name = 'Test Chatter' limit 1][0].NetworkId, feedItemInput);
            
            String feedElementId = feedElement.id;
 
            ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
            mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            messageBodyInput = new ConnectApi.MessageBodyInput();
            textSegmentInput = new ConnectApi.TextSegmentInput();
             
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
             
            textSegmentInput.text = 'Does anyone in this group have an idea? ';
            messageBodyInput.messageSegments.add(textSegmentInput);
             
            mentionSegmentInput.id = getCommunityUserId();
            messageBodyInput.messageSegments.add(mentionSegmentInput);
             
            commentInput.body = messageBodyInput;
             
            ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postCommentToFeedElement([SELECT NetworkId FROM NetworkMember WHERE Network.Name = 'Test Chatter' limit 1][0].NetworkId, feedElementId, commentInput, null);

            
            Test.stopTest();
            
            
        }
        
        
    }
    
    private static Id getCommunityUserId(){
        
        return [SELECT network.name, networkId, memberID FROM NetworkMember WHERE Network.Name = 'Test Chatter' LIMIT 1].MemberId;  
    }
}