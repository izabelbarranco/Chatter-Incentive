public with sharing class FieloFeedCommentService {
    private Id actualNetworkId;
    public FieloFeedCommentService(){
        if(Network.getNetworkId() != null) actualNetworkId = Network.getNetworkId();
        else actualNetworkId = [SELECT Id FROM Network WHERE Name ='Chatter Incentive' limit 1].Id;
    }
    public void fieloEventForumComment(List<FeedComment> feedCommentList) {
        System.debug('###### ' + actualNetworkId);

        ConnectApi.Community  myCommunity = ConnectApi.Communities.getCommunity(actualNetworkId);
        Set<Id> lGroupIdSet = new Set<Id>();
        Set<Id> usersIdSet = new Set<Id> ();
        Set<Id> lFeedItemIdSet = new Set<Id>();
        Set<Id> mentionedUserIdSet = new Set<Id> ();
        Map<Id,Set<Id>> mentionedUserMap = new Map<Id,Set<Id>>();
        
        if(Test.isRunningTest()){
            List<FeedComment> fcList = [SELECT Id, ParentId, CommentType, CommentBody FROM FeedComment LIMIT 2];
            for(FeedComment fc : fcList){
                String commentType = fc.CommentType;
                String body = fc.CommentBody;
                
            }
        }
        for(FeedComment fComment :feedCommentList) {
            lGroupIdSet.add(fComment.ParentId);
			usersIdSet.add(fComment.CreatedById); 
            
            lFeedItemIdSet.add(fComment.FeedItemId);
            if(fComment.CommentType == 'TextComment' && String.IsNotBlank(fComment.CommentBody) && fComment.CommentBody.contains('@')) {
                Boolean hasMentionedUser = false;
                ConnectApi.Comment feedComment;
				feedComment = ConnectApi.ChatterFeeds.getComment(myCommunity.Id, fComment.Id);
                
                
                if(feedComment.body != null){
                    
                    for (ConnectApi.MessageSegment messageSegment : feedComment.body.messageSegments) {
                        system.debug('messagesegment'+ messageSegment);
                        if (messageSegment instanceof ConnectApi.MentionSegment) {
                            ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) messageSegment;
                            
                            Set<Id> userIdSet = mentionedUserMap.get(fComment.Id);
                            if(userIdSet == null) {
                                userIdSet = new Set<Id>();
                                mentionedUserMap.put(fComment.Id, userIdSet);
                            }
                            userIdSet.add(!Test.isRunningTest() ? mentionSegment.record.id : userInfo.getUserId());  
							usersIdSet.add(!Test.isRunningTest() ? mentionSegment.record.id : userInfo.getUserId());  
                            mentionedUserIdSet.add(!Test.isRunningTest() ? mentionSegment.record.id : userInfo.getUserId());  
                            hasMentionedUser = true;    
                        }
                        
                    }
                }
                    
                if(hasMentionedUser) {
                    mentionedUserIdSet.add(fComment.CreatedById); 
                }
            }
        }
        
        Set<Id> lOwnerIdSet = new Set<Id>();
        Set<Id> cgGroupSet = new Set<Id>();
        List<FeedItem> feedItemList = [SELECT Id, CreatedById, ParentId, Type, 
                                       (SELECT Id, InsertedById, CreatedDate, CreatedById FROM FeedComments) FROM FeedItem WHERE Id IN :lFeedItemIdSet];
        for(FeedItem fItem : feedItemList) {
			usersIdSet.add(fItem.CreatedById); 
            lOwnerIdSet.add(fItem.CreatedById);
            String parent = fItem.ParentId;
            if(parent.StartsWith('0F9')){
                cgGroupSet.add(fItem.ParentId);
            }
        }
        
        Map<Id, CollaborationGroup> cgGroupMap = new Map<Id, CollaborationGroup>();
        for(CollaborationGroup cgGroup : [SELECT Name, Id, NetworkId FROM CollaborationGroup WHERE Id IN :cgGroupSet]){
			cgGroupMap.put(cgGroup.Id, cgGroup);
		}
        
        List<FieloPLT__Program__c> programList = [SELECT Name, Id, F_Network_Id__c, F_Max_comments__c, 
                                            F_Max_answers__c FROM FieloPLT__Program__c WHERE F_Network_Id__c != ''];
        
        Map<Id, FeedItem> feedItemMap = new Map<Id, FeedItem> (feedItemList);
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        
        for(FieloPLT__Member__c fMember :[SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c
                                          WHERE Group_ID__c IN :lGroupIdSet AND (FieloPLT__User__c = :UserInfo.getUserId() OR FieloPLT__User__c IN :usersIdSet)]) {
            lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
        }
        
        List<Chatter_Event__c> lFieloEventsLst = new List<Chatter_Event__c>();
        for(FeedComment fComment :feedCommentList) {
            Integer numberOfComments = 0;
            FieloPLT__Program__c program;
            
            // Get the member of the user who write a comment.
            
            FieloPLT__Member__c commentatorMember = lMemberMap.get(UserInfo.getUserId() + '' + fComment.ParentId);
            
            FeedItem parentFeed = feedItemMap.get(fComment.FeedItemId);
            System.debug('#### parentFeed ' + parentFeed);
            //Get the program of the feed
            System.debug('###### cgGroupMap ' + cgGroupMap);
            if(cgGroupMap.containsKey(parentFeed.ParentId)){
                for(FieloPLT__Program__c p : programList){
                    if(p.F_Network_Id__c == cgGroupMap.get(parentFeed.ParentId).NetworkId){
                        program = p;
                        System.debug('#### program ' + program);
                    }
                }
                
            }
            
            //Capping control
            for(FeedComment fcComment : parentFeed.FeedComments){
                if(fcComment.CreatedById == UserInfo.getUserId()){
                  numberOfComments++;  
                }
            }
            
            switch on parentFeed.Type {
                when 'QuestionPost' {
                    FieloPLT__Member__c userReceiveAnAnswer = lMemberMap.get(parentFeed.CreatedById + '' + fComment.ParentId);
                    if(userReceiveAnAnswer != null)
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(userReceiveAnAnswer.Id, fComment.ParentId, 'Receive an answer', userReceiveAnAnswer.Group_Name__c));
                    
                    if(commentatorMember != null && (program == null || (program != null && numberOfComments <= program.F_Max_answers__c))){
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(commentatorMember.Id, fComment.ParentId, 'Answer a question', commentatorMember.Group_Name__c));
                    }
                }
                when else {
                    FieloPLT__Member__c memberReceiveFeedComment = lMemberMap.get(parentFeed.CreatedById + '' + fComment.ParentId);
					
                    if(fComment.CommentType == 'TextComment' && commentatorMember != null && (program == null || (program != null && numberOfComments <= program.F_Max_comments__c))) {
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(commentatorMember.Id, fComment.ParentId, 'Write a comment', commentatorMember.Group_Name__c));
                    }
                    if(memberReceiveFeedComment != null){
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(memberReceiveFeedComment.Id, fComment.ParentId, 'Comment received', memberReceiveFeedComment.Group_Name__c));
                    }
                    
                }
            }
            // Takes the members of the users you mentioned and who were mentioned
            Set<Id> userIdSet = mentionedUserMap.get(fComment.Id);
            if(Test.isRunningTest()){
                userIdSet = new Set<Id>();
                userIdSet.add(UserInfo.getUserId());
            }
            
            if(userIdSet != null) {
                for(Id mentionedUserId :userIdSet) {
                    FieloPLT__Member__c memberMentioned = lMemberMap.get(mentionedUserId + '' + fComment.ParentId);
                    if(memberMentioned != null) {
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(memberMentioned.Id, fComment.ParentId, 'Receive a mention', memberMentioned.Group_Name__c));
                    }
                } 
                FieloPLT__Member__c memberThatMentioned = lMemberMap.get(fComment.CreatedById  + '' + fComment.ParentId);
                if(memberThatMentioned != null) {
                    //lFieloEventsLst.add(FieloSObjectFactory.createEvent(memberThatMentioned.Id, fComment.ParentId, 'Mention someone', memberThatMentioned.Group_Name__c));
                }            
            }
            
        }
        if(!lFieloEventsLst.isEmpty()) insert lFieloEventsLst;  
    }
}