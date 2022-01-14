public with sharing class FieloFeedItemService {
    private static final String TEXT_TYPE = 'TextPost';
    private static final String RYPPLE_TYPE = 'RypplePost';
    private Id actualNetworkId;
    public FieloFeedItemService(){
        if(Network.getNetworkId() == null) actualNetworkId = [SELECT Id FROM Network WHERE Name ='Chatter Incentive' limit 1].Id;
        else actualNetworkId = Network.getNetworkId();
        System.debug('actualNetworkId: '+ actualNetworkId);
    }
    public List<Chatter_Event__c> fieloEventForumPost( List<FeedItem> aFeedItemNewLst ) {
        System.debug('Entrada fieloEvent');
        ConnectApi.Community myCommunity = ConnectApi.Communities.getCommunity(actualNetworkId);
                
        Set<Id> sharedFeedItemIdSet = new Set<Id>();
        Set<Id> lGroupIdSet = new Set<Id>();
        Set<Id> usersIdSet = new Set<Id> ();
        Map<Id,Set<Id>> gratefulUserMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mentionedUserMap = new Map<Id,Set<Id>>();
        Map<Id,Id> AnswerAQuestionUserMap = new Map<Id,Id>();      
        for(FeedItem fItem :aFeedItemNewLst) {
            lGroupIdSet.add(fItem.ParentId);
            if( ( fItem.Type == TEXT_TYPE || fItem.Type == RYPPLE_TYPE ) && String.IsNotBlank(fItem.Body) && fItem.Body.contains('@')) {
                Boolean hasMentionedUser = false;
                ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(myCommunity.Id, fItem.Id);
                List<ConnectApi.MessageSegment> messageSegments = feedItem.body.messageSegments;
                for (ConnectApi.MessageSegment messageSegment : messageSegments) {
                    if (messageSegment instanceof ConnectApi.MentionSegment) {
                        ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) messageSegment;
                        Set<Id> userIdSet;
                        if(fItem.Type == TEXT_TYPE) {
                            userIdSet = mentionedUserMap.get(fItem.Id);
                            if(userIdSet == null) {
                                userIdSet = new Set<Id>();
                                mentionedUserMap.put(fItem.Id, userIdSet);
                            }
                        }
                        else {
                            userIdSet = gratefulUserMap.get(fItem.Id);
                            if(userIdSet == null) {
                                userIdSet = new Set<Id>();
                                gratefulUserMap.put(fItem.Id, userIdSet);
                            }
                        }
                        userIdSet.add(mentionSegment.record.id);  
                        usersIdSet.add(mentionSegment.record.id);  
                        hasMentionedUser = true;          
                    }
                }
                if(hasMentionedUser) {
                    usersIdSet.add(fItem.CreatedById); 
                }
            }
            else if(fItem.Type == 'QuestionPost') {
                AnswerAQuestionUserMap.put(fItem.Id, fItem.CreatedById);
                usersIdSet.add(fItem.CreatedById);
            }         
        } 
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c fMember :[SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c 
                                          WHERE Group_ID__c IN :lGroupIdSet AND (FieloPLT__User__c = :UserInfo.getUserId() OR FieloPLT__User__c IN :usersIdSet)]) {
                                              lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
                                          }
        List<Chatter_Event__c> lFieloEventsLst = new List<Chatter_Event__c>();
        for(FeedItem fItem :aFeedItemNewLst) {
            // Get the member of the user who made the comment
            if(fItem.Type == TEXT_TYPE) {
                FieloPLT__Member__c commentatorMember = lMemberMap.get(UserInfo.getUserId() + '' + fItem.ParentId);
                if(commentatorMember != null) {
                    lFieloEventsLst.add(FieloSObjectFactory.createEvent(commentatorMember.Id, fItem.ParentId, 'Write a post', commentatorMember.Group_Name__c));
                }
            }
            // Takes the members of the users you mentioned and who were mentioned
            Set<Id> userIdSet = mentionedUserMap.get(fItem.Id);
            if(userIdSet != null) {
                for(Id mentionedUserId :userIdSet) {
                    FieloPLT__Member__c memberMentioned = lMemberMap.get(mentionedUserId + '' + fItem.ParentId);
                    if(memberMentioned != null) {
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(memberMentioned.Id, fItem.ParentId, 'Receive a mention', memberMentioned.Group_Name__c));
                    }
                } 
                FieloPLT__Member__c memberThatMentioned = lMemberMap.get(fItem.CreatedById  + '' + fItem.ParentId);
                if(memberThatMentioned != null) {
                    //lFieloEventsLst.add(FieloSObjectFactory.createEvent(memberThatMentioned.Id, fItem.ParentId, 'Mention someone', memberThatMentioned.Group_Name__c));
                }            
            } 
            // Takes the members of the users send thanks and who were grateful
            userIdSet = gratefulUserMap.get(fItem.Id);
            if(userIdSet != null) {
                for(Id gratefulUserId :userIdSet) {
                    FieloPLT__Member__c membergrateful = lMemberMap.get(gratefulUserId + '' + fItem.ParentId);
                    if(membergrateful != null) {
                        //lFieloEventsLst.add(FieloSObjectFactory.createEvent(membergrateful.Id, fItem.ParentId, 'Receive Thanks', membergrateful.Group_Name__c));
                    }
                } 
                FieloPLT__Member__c memberThatgrateful = lMemberMap.get(fItem.CreatedById  + '' + fItem.ParentId);
                if(memberThatgrateful != null) {
                    //lFieloEventsLst.add(FieloSObjectFactory.createEvent(memberThatgrateful.Id, fItem.ParentId, 'Thank Someone', memberThatgrateful.Group_Name__c));
                }            
            } 
            
            // Takes the member of the user who asked a question
            FieloPLT__Member__c answerAQuestionUser = lMemberMap.get(AnswerAQuestionUserMap.get(fItem.Id) + '' + fItem.ParentId);
            if(answerAQuestionUser != null) {
                //lFieloEventsLst.add(FieloSObjectFactory.createEvent(answerAQuestionUser.Id, fItem.ParentId, 'Ask a question', answerAQuestionUser.Group_Name__c));
            }
            
        }
        if(!lFieloEventsLst.isEmpty()) insert lFieloEventsLst;
        return lFieloEventsLst;
    }
    
    public void fieloEventBestAnswer(List<FeedItem> aFeedItemNewLst) {
              
        
        Set<Id> groupIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id> ();
        Set<Id> feedCommentIdSet = new Set<Id>();
        Map<Id,Id> ownerQuestionUserMap = new Map<Id,Id>();
        List<FeedItem> feedItemLst = new List<FeedItem>();
        for(FeedItem fItem :aFeedItemNewLst) {
            if(fItem.BestCommentId != null /*&& ((FeedItem)trigger.oldMap.get(fItem.Id)).BestCommentId != fItem.BestCommentId */) {
                ownerQuestionUserMap.put(fItem.Id, fItem.CreatedById);
                groupIdSet.add(fItem.ParentId);
                userIdSet.add(fItem.CreatedById);
                feedCommentIdSet.add(fItem.BestCommentId);
                feedItemLst.add(fItem);
            }
        }  
        
        if(feedItemLst.isEmpty()) return;
        
        Map<Id,Id> ownerBestAnswerMap = new Map<Id,Id>();
        for(FeedComment fComment :[SELECT Id, CreatedById FROM FeedComment WHERE Id IN :feedCommentIdSet]) {
            ownerBestAnswerMap.put(fComment.Id, fComment.CreatedById);
            userIdSet.add(fComment.CreatedById);
        }
        
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c fMember :[SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c 
                                          WHERE Group_ID__c IN :groupIdSet AND FieloPLT__User__c IN :userIdSet]) {
                                              lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
                                          }
        
        List<Chatter_Event__c> lFieloEventsLst = new List<Chatter_Event__c>();
        for(FeedItem fItem :feedItemLst) {
            FieloPLT__Member__c ownerQuestionMember = lMemberMap.get(ownerQuestionUserMap.get(fItem.Id) + '' + fItem.ParentId);
            if(ownerQuestionMember != null) {
                //lFieloEventsLst.add(FieloSObjectFactory.createEvent(ownerQuestionMember.Id, fItem.ParentId, 'Mark an answer as best', ownerQuestionMember.Group_Name__c, fItem.Id));
            }  
            FieloPLT__Member__c ownerBestAnswer = lMemberMap.get(ownerBestAnswerMap.get(fItem.BestCommentId) + '' + fItem.ParentId);
            if(ownerBestAnswer != null) {
                lFieloEventsLst.add(FieloSObjectFactory.createEvent(ownerBestAnswer.Id, fItem.ParentId, 'Your answer is marked as best', ownerBestAnswer.Group_Name__c, fItem.Id));
            }             
        }
        if(!lFieloEventsLst.isEmpty()) insert lFieloEventsLst; 
    }
    
    public void fieloSharePost(List<FeedItem> aFeedItemNewLst){        
        System.debug('Entrada fieloSharePost');
        List<Chatter_Event__c> lFieloEventsLst = new List<Chatter_Event__c>();
        
        Set<Id> lGroupIdSet = new Set<Id>();
        Set<Id> usersIdSet = new Set<Id> ();
        
        for(FeedItem fItem :aFeedItemNewLst) {
            lGroupIdSet.add(fItem.ParentId);
			usersIdSet.add(fItem.InsertedById); 
        }
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c fMember :[SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c 
                                          WHERE Group_ID__c IN :lGroupIdSet AND (FieloPLT__User__c = :UserInfo.getUserId() OR FieloPLT__User__c IN :usersIdSet)]) {
            lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
        }
        
        for(FeedItem fItem : aFeedItemNewLst) {
            System.debug('#### fItem ' + fItem);
            /*
            if(fItem.Type == 'AdvancedTextPost' && lMemberMap.containsKey(fItem.InsertedById + '' + fItem.ParentId)){
                FieloPLT__Event__c ev1 = new FieloPLT__Event__c();
                ev1.FieloPLT__Member__c = lMemberMap.get(fItem.InsertedById + '' + fItem.ParentId).Id;
                ev1.FieloPLT__Type__c = 'Share a Post';
                ev1.FieloPLT__EventDate__c	= System.today();
                ev1.Feed_Item_Id__c	= fItem.Id;
                ev1.Group_ID__c = fItem.ParentId;
                ev1.Group_Name__c = fItem.Parent.Name;
                lFieloEventsLst.add(ev1);
            }*/
        }
        
        System.debug('#### lFieloEventsLst ' + lFieloEventsLst.size());
        if(lFieloEventsLst.size() > 0){
            insert lFieloEventsLst;
        }
    }
}