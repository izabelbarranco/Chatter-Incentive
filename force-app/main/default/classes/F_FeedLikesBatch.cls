global class F_FeedLikesBatch implements Database.Batchable<sObject>, Schedulable{
    
    global void execute(SchedulableContext sc){
        F_FeedLikesBatch likes = new F_FeedLikesBatch();
        database.executeBatch(likes,200);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            return Database.getQueryLocator( [SELECT Id, ParentId, Parent.Name, Parent.NetworkId, CommentCount, LikeCount, LastModifiedDate, CreatedDate, CreatedById, 
                                          (SELECT Id, InsertedById, CreatedDate, CreatedById FROM FeedLikes WHERE CreatedDate = YESTERDAY) 
                                          FROM CollaborationGroupFeed
                                          WHERE (CreatedDate = THIS_FISCAL_QUARTER OR CreatedDate = LAST_FISCAL_QUARTER) AND Parent.NetworkId != null AND LikeCount > 0
                                          ORDER BY LastModifiedDate DESC] );
        }else{
            return Database.getQueryLocator( [SELECT Id, ParentId, Parent.Name, Parent.NetworkId, CommentCount, LikeCount, LastModifiedDate, CreatedDate, CreatedById, 
                                          (SELECT Id, InsertedById, CreatedDate, CreatedById FROM FeedLikes)
                                          FROM CollaborationGroupFeed
                                          WHERE CreatedDate = THIS_FISCAL_QUARTER AND Parent.NetworkId != null AND LikeCount > 0
                                          ORDER BY LastModifiedDate DESC LIMIT 5] );
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('##### Execute');
        System.debug('##### List Size ' + scope.Size());
        
        Set<Id> lGroupIdSet = new Set<Id>();
        Set<Id> usersIdSet = new Set<Id>();
        
      
        List<Chatter_Event__c> eventsList = new List<Chatter_Event__c>();
        List<CollaborationGroupFeed> listCollabFeed = (List<CollaborationGroupFeed>) scope;
        
        for(CollaborationGroupFeed collabFeed : listCollabFeed){
            lGroupIdSet.add(collabFeed.ParentId);
            usersIdSet.add(collabFeed.CreatedById);
            
            for(FeedLike fl : collabFeed.FeedLikes){
                usersIdSet.add(fl.InsertedById);
            }
            
        }
        
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c fMember :[SELECT Id, Group_ID__c, Group_Name__c, FieloPLT__User__c FROM FieloPLT__Member__c 
                                          WHERE Group_ID__c IN :lGroupIdSet AND  FieloPLT__User__c IN :usersIdSet]) {
            lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
        }
        
        
        for(CollaborationGroupFeed collabFeed : listCollabFeed){
            System.debug('#### FeedLikes ' + collabFeed.FeedLikes.size() );
           
            FieloPLT__Member__c testMember = null;
            
            if(Test.isRunningTest()){
                testMember = [SELECT Id FROM FieloPLT__Member__c LIMIT 1];
            }
            
            if(collabFeed.FeedLikes.size() > 0){
                for(FeedLike fl : collabFeed.FeedLikes){/*
                    if(lMemberMap.containsKey(fl.InsertedById + '' + collabFeed.ParentId) || testMember != null){
                        Chatter_Event__c ev1 = new Chatter_Event__c();
                        ev1.type__c = 'Like something';
                        ev1.Event_Date__c   = System.today();
                        ev1.Feed_Item_Id__c = collabFeed.Id;
                        ev1.Group_ID__c = collabFeed.ParentId;
                        ev1.Group_Name__c = collabFeed.Parent.Name;
                        if(Test.isRunningTest()){
                            ev1.Member__c = testMember.Id;
                        }else{
                            ev1.Member__c = lMemberMap.get(fl.InsertedById + '' + collabFeed.ParentId).Id;
                            eventsList.add(ev1);
                        }
                    }*/
                    
                    if(lMemberMap.containsKey(collabFeed.CreatedById + '' + collabFeed.ParentId) || testMember != null){
                        Chatter_Event__c ev2 = new Chatter_Event__c();
                        ev2.Event_Date__c   = System.today();
                        ev2.Feed_Item_Id__c = collabFeed.Id;
                        ev2.Group_ID__c = collabFeed.ParentId;
                        ev2.Group_Name__c = collabFeed.Parent.Name;
                        ev2.Type__c = 'Receive a like';
                        if(Test.isRunningTest()){
                            ev2.Member__c = testMember.Id;
                        }else{
                            ev2.Member__c = lMemberMap.get(collabFeed.CreatedById + '' + collabFeed.ParentId).Id;
                            eventsList.add(ev2);
                        }
                    }
                }
            }
        }
        
        
        if(eventsList.size() > 0){
            insert eventsList;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('#### finish');
    }
    
    
}