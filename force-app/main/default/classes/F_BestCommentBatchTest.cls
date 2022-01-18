@IsTest(SeeAllData=true)
public class F_BestCommentBatchTest 
{
    static testMethod void testMethod1() 
    {
        FieloPLT.CacheAPI.enableCacheAccess(false);
        
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //adminUser.userRoleId = testRole.id;
        
        //update adminUser;
        
        
        system.runAs(adminUser){
            
            List<FeedItem> feedItems = new List<FeedItem>();
            list<user> testUsers = [select id from user limit 2];
            for (Integer i = 0; i < 50; i++)
            {
                FeedItem feedItem = new FeedItem();
                feedItem.Title = Peak_Onboarding_TestConstants.TEST_MESSAGE;
                feedItem.Body = Peak_Onboarding_TestConstants.TEST_DESCRIPTION;
                feedItem.parentId = testUsers[0].id;
                //feedItem.NetworkScope = system.Network.NetworkId;
                feedItem.Type = 'QuestionPost';
                feedItem.CreatedById = testUsers[1].id;
                feedItems.add(feedItem);
            }
            
            //insert feedItems;
            
            Test.startTest();
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            textSegmentInput.text = 'Does anyone know anyone with contacts here?';
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            // Mention a group.
            mentionSegmentInput.id = adminUser.Id;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            
            // Use a record ID for the subject ID.
            feedItemInput.subjectId = adminUser.Id;
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement([SELECT NetworkId FROM NetworkMember WHERE Network.Name = 'Test Chatter' limit 1][0].NetworkId, feedItemInput);
            
            
            F_BestCommentBatch comment = new F_BestCommentBatch();
            DataBase.executeBatch(comment); 
            
            Test.stopTest();
            
        }
    }
    
    @isTest
    static void test() {
        
        FieloPLT.CacheAPI.enableCacheAccess(false);
        
        
        String CRON_EXP = '0 0 23 * * ?';
        F_BestCommentBatch b0 = new F_BestCommentBatch();
        Test.startTest();
        String job0 = System.schedule('ScheduledApexTest', CRON_EXP, b0);
        Test.stopTest();
    }
}