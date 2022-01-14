public with sharing class F_GenerateFieloEventsByFeedItems_sch_bch implements Schedulable, Database.Batchable<sObject>, Database.Stateful {

    final Network myNetwork = [SELECT Id FROM Network WHERE Name ='FieloOrgCisco'];
    final ConnectApi.Community  myCommunity = ConnectApi.Communities.getCommunity(myNetwork.Id);

    /*
    F_GenerateFieloEventsByFeedItems_sch_bch schClass = new F_GenerateFieloEventsByFeedItems_sch_bch();
    String sch = '20 30 8 10 2 ?';
    String jobID = system.schedule('Generate Fielo Events By FeedItems', sch, schClass);
    */

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new F_GenerateFieloEventsByFeedItems_sch_bch()); 
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // The SystemModstamp field can be used to limit feeds by last modified date
        return Database.getQueryLocator([SELECT Id, ParentId, CreatedById, Type FROM FeedItem WHERE IsClosed = false AND Type IN ('QuestionPost','TextPost','AdvancedTextPost')]);
    }

    public void execute(Database.BatchableContext BC, List<FeedItem> aFeedItemLst) {

        Set<Id> lGroupIdSet = new Set<Id>();
        Set<Id> lUserIdSet = new Set<Id>();   
        Set<Id> sharedFeedItemIdSet = new Set<Id>();     
        Map<Id,Set<Id>> lUserGroupLikePostMap = new Map<Id,Set<Id>>();
        Map<Id,Id> sharedAndOriginalFeedMap = new Map<Id,Id>();  
        for(FeedItem fItem :aFeedItemLst) {
            if(fItem.Type == 'TextPost' || fItem.Type == 'QuestionPost') {  
                ConnectApi.ChatterLikePage lLikePage = ConnectApi.ChatterFeeds.getLikesForFeedElement(myCommunity.Id, fItem.Id);
                system.debug('FeedItemId: ' + fItem.Id);            
                system.debug('Test Result: ' + JSON.serialize(lLikePage));         
                
                if(!lLikePage.items.isEmpty()) {   
                    lGroupIdSet.add(fItem.ParentId);
                    Set<Id> lUserLikePostIdSet = new Set<Id>();
                    Boolean hasLike = false;
                    for(ConnectApi.ChatterLike lChatterLike: lLikePage.items) {     
                        lUserLikePostIdSet.add(lChatterLike.user.id);                    
                        hasLike = true;
                    }   
                    if(hasLike) {
                        lUserIdSet.add(fItem.CreatedById);
                        lUserIdSet.addAll(lUserLikePostIdSet);
                        lUserGroupLikePostMap.put(fItem.Id, lUserLikePostIdSet);
                    }             
                }
            }
            else if(fItem.Type == 'AdvancedTextPost') {                
                ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(myCommunity.Id, fItem.Id);
                sharedFeedItemIdSet.add(feedItem.capabilities.feedEntityShare.feedEntity.id);
                sharedAndOriginalFeedMap.put(fItem.Id, feedItem.capabilities.feedEntityShare.feedEntity.id);
            } 
        }

        
        Map<Id,FeedItem> sharedFeedItemMap = new Map<Id,FeedItem>();
        if(!sharedFeedItemIdSet.isEmpty()) {
            for(FeedItem fItem :[SELECT Id, CreatedById, ParentId, Type FROM FeedItem WHERE Id IN :sharedFeedItemIdSet]) {
                sharedFeedItemMap.put(fItem.id, fItem);
                lUserIdSet.add(fItem.CreatedById);
                lGroupIdSet.add(fItem.ParentId);
            }
        }

        Set<Id> lMemberIdSet = new Set<Id>();
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c fMember :[SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c 
                WHERE Group_ID__c IN :lGroupIdSet AND FieloPLT__User__c IN :lUserIdSet]) {
            lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
            lMemberIdSet.add(fMember.Id);
        }  
        
        Set<String> lMemberWithGroupAndTypeSet = new Set<String>();
        for(Chatter_Event__c fEvent :[SELECT Id, member__c, Group_ID__c, 
                type__c, Feed_Item_Id__c 
                FROM Chatter_Event__c 
                WHERE member__c IN :lMemberIdSet 
                AND Group_ID__c IN :lGroupIdSet
                AND type__c IN ('Like something','Receive a like','Someone shares your post','Share a post')]) {
            lMemberWithGroupAndTypeSet.add(fEvent.member__c + '' + fEvent.Feed_Item_Id__c + '' + fEvent.type__c);
        }              
        
        List<Chatter_Event__c> lFieloEventsLst = new List<Chatter_Event__c>();
        for(FeedItem fItem :aFeedItemLst) {
            Set<Id> lUserLikePostIdSet = lUserGroupLikePostMap.get(fItem.Id);
            if(lUserLikePostIdSet != null) {
                for(Id userLikePostId :lUserLikePostIdSet) {
                    FieloPLT__Member__c memberLikePost = lMemberMap.get(userLikePostId + '' + fItem.ParentId);
                    if(memberLikePost != null && !lMemberWithGroupAndTypeSet.contains(memberLikePost.Id + '' + fItem.Id + 'Like something')) {
                        //lFieloEventsLst.add(createFieloEvent(memberLikePost.Id, fItem.ParentId, fItem.Id, 'Like something', memberLikePost.Group_Name__c, memberLikePost.FieloPLT__User__c));
                    }
                } 
                FieloPLT__Member__c receiveALikeMember = lMemberMap.get(fItem.CreatedById  + '' + fItem.ParentId);
                if(receiveALikeMember != null && !lMemberWithGroupAndTypeSet.contains(receiveALikeMember.Id + '' + fItem.Id + 'Receive a like')) {
                    lFieloEventsLst.add(createFieloEvent(receiveALikeMember.Id, fItem.ParentId, fItem.Id, 'Receive a like', receiveALikeMember.Group_Name__c, receiveALikeMember.FieloPLT__User__c));
                }            
            } 

            Id sharedFeedItemId = sharedAndOriginalFeedMap.get(fItem.Id);
            if(sharedFeedItemId != null) {
                FeedItem sharedFeedItem = sharedFeedItemMap.get(fItem.id);
                if(sharedFeedItem != null) {
                    FieloPLT__Member__c sharedFeedItemUserOwner = lMemberMap.get(sharedFeedItem.CreatedById + '' + sharedFeedItem.ParentId);
                    if(sharedFeedItemUserOwner != null && !lMemberWithGroupAndTypeSet.contains(sharedFeedItemUserOwner.Id + '' + fItem.Id + 'Someone shares your post')) {
                        //lFieloEventsLst.add(createFieloEvent(sharedFeedItemUserOwner.Id, sharedFeedItem.ParentId, sharedFeedItem.Id, 'Someone shares your post', sharedFeedItemUserOwner.Group_Name__c, sharedFeedItemUserOwner.FieloPLT__User__c));
                    }
                    
                    FieloPLT__Member__c sharedFeedItemUser = lMemberMap.get(UserInfo.getUserId() + '' + sharedFeedItem.ParentId);
                    if(sharedFeedItemUser != null && !lMemberWithGroupAndTypeSet.contains(sharedFeedItemUser.Id + '' + fItem.Id + 'Share a post')) {
                        //lFieloEventsLst.add(createFieloEvent(sharedFeedItemUser.Id, sharedFeedItem.ParentId, sharedFeedItem.Id, 'Share a post', sharedFeedItemUser.Group_Name__c, sharedFeedItemUser.FieloPLT__User__c));
                    }
                }
            }
        }
        
        if(!lFieloEventsLst.isEmpty()) insert lFieloEventsLst;
    }

    public void finish(Database.BatchableContext BC) {
    }        

    private static Chatter_Event__c createFieloEvent(Id memberId, Id groupId, Id feedItemId, String eventType, String groupName, Id feedItemOwner) {
        return new Chatter_Event__c(
                member__c = memberId,
                Group_ID__c = groupId,
                Feed_Item_Id__c = feedItemId,
                type__c = eventType,
                Group_Name__c = groupName,
                OwnerId = feedItemOwner
            );
    }
}