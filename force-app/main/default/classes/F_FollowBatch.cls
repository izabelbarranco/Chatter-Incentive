global class F_FollowBatch implements Database.Batchable<sObject>, Schedulable{
    
    global void execute(SchedulableContext sc){
        F_FollowBatch follow = new F_FollowBatch();
        database.executeBatch(follow,200);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            return Database.getQueryLocator( [SELECT Id, ParentId, SubscriberId, CreatedDate FROM EntitySubscription WHERE CreatedDate = YESTERDAY] );
        }else{
            return Database.getQueryLocator( [SELECT Id, ParentId, SubscriberId, CreatedDate FROM EntitySubscription WHERE CreatedDate = TODAY] );
        }
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('##### Execute');
        System.debug('##### List Size ' + scope.Size());
        
        List<EntitySubscription> followList = (List<EntitySubscription>) scope;
        List<Chatter_Event__c> eventsList = new List<Chatter_Event__c>();
        
        Set<Id> usersIdSet = new Set<Id>();
        for(EntitySubscription follow : followList){
            usersIdSet.add(follow.SubscriberId);
            String parentId = follow.ParentId;
            if(parentId.startswith('005')){
                usersIdSet.add(follow.parentId);
            }
        }
        Map<String,FieloPLT__Member__c> lMemberMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c fMember :[SELECT Id, FieloPLT__User__c, Group_ID__c FROM FieloPLT__Member__c WHERE FieloPLT__User__c IN :usersIdSet]) {
            lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
        }
        Map<String,CollaborationGroup> cgMap = new Map<String,CollaborationGroup>();
        for(CollaborationGroup cg : [SELECT Id, Name, CollaborationType, NetworkId FROM CollaborationGroup]){
            cgMap.put(cg.Name, cg);
        }
        
		Map<Id, CollaborationGroup> userPrimaryComMap = new Map<Id, CollaborationGroup>();
        List<FieloPLT__Member__c> memberList = new List<FieloPLT__Member__c>();
		List<FieloPLT__Program__c> programs = [SELECT Id, Name,F_Network_Id__c FROM FieloPLT__Program__c]; 
        for(User u : [SELECT Id, Name, Email, CX_Role__c FROM User WHERE Id IN :usersIdSet AND CX_Role__c != '']){
            
            if(cgMap.containsKey(u.CX_Role__c)){
				userPrimaryComMap.put(u.Id, cgMap.get(u.CX_Role__c));  
                if(!lMemberMap.containsKey(u.Id + '' + cgMap.get(u.CX_Role__c).Id)){
                    FieloPLT__Member__c member = new FieloPLT__Member__c();
                    member.FieloPLT__Email__c = u.Email;
                    for(FieloPLT__Program__c program : programs){
                        if(program.F_Network_Id__c == cgMap.get(u.CX_Role__c).NetworkId){
                    		member.FieloPLT__Program__c = program.Id;
                        } 
                    }
                    member.FieloPLT__Type__c = 'Employee';
                    member.FieloPLT__User__c = u.Id;
                    member.Group_ID__c = cgMap.get(u.CX_Role__c).Id;
                    member.Group_Name__c = u.CX_Role__c;
                    member.Name = u.Name;   
                    member.F_ExternalID__c = u.Id + '-' + cgMap.get(u.CX_Role__c).Id;
                    memberList.add(member);
                }
            }
        }
        
        if(memberList.size() > 0){
            if(Test.isRunningTest()){
                FieloPLT__Triggers__c trig = new FieloPLT__Triggers__c();
                trig.SetupOwnerId = userInfo.getUserId();
                trig.FieloPLT__Member__c = false;
                insert trig;
            }
            insert memberList;
            lMemberMap.clear();
            for(FieloPLT__Member__c fMember :[SELECT Id, FieloPLT__User__c, Group_ID__c FROM FieloPLT__Member__c WHERE FieloPLT__User__c IN :usersIdSet]) {
                lMemberMap.put(fMember.FieloPLT__User__c + '' + fMember.Group_ID__c, fMember);
            }
        }
        /*
        Map<String,Chatter_Event__c> lEventMap = new Map<String,Chatter_Event__c>();
        for(Chatter_Event__c event : [SELECT Id, Member__c, type__c, Feed_Item_Id__c FROM Chatter_Event__c
                                        WHERE Feed_Item_Id__c != '' AND (type__c = 'Follow a topic' 
                                                                         OR type__c = 'Follow a person' OR type__c = 'Get followed by another person')] ){
                                                                             lEventMap.put(event.type__c + '' + event.member__c + '' + event.Feed_Item_Id__c, event);
                                                                             
                                                                             System.debug('lEventMap' + event.type__c + '' + event.member__c + '' + event.Feed_Item_Id__c);
                                                                         }
        
        for(EntitySubscription follow : followList){
            String parentId = follow.ParentId;
            FieloPLT__Member__c followingMember = lMemberMap.get(follow.SubscriberId + '' + userPrimaryComMap.get(follow.SubscriberId)?.Id);

            if(parentId.StartsWith('005')){
                //follow a user
                if(!lEventMap.containsKey('Follow a person' + '' + followingMember.Id + '' + parentId)){
                    Chatter_Event__c ev1 = new Chatter_Event__c();
                    ev1.member__c = followingMember.Id;
                    ev1.type__c = 'Follow a person';
                    ev1.Event_Date__c	= System.today();
                    ev1.Feed_Item_Id__c	= parentId;
                    eventsList.add(ev1);
                }
                FieloPLT__Member__c memberBeingFollowed = lMemberMap.get(parentId + '' + userPrimaryComMap.get(parentId)?.Id);
                
                if(!lEventMap.containsKey('Get followed by another person' + '' + memberBeingFollowed.Id + '' + follow.SubscriberId)){
                    FieloPLT__Event__c ev2 = new FieloPLT__Event__c();
                    ev2.FieloPLT__Member__c = memberBeingFollowed.Id;
                    ev2.FieloPLT__Type__c = 'Get followed by another person';
                    ev2.FieloPLT__EventDate__c	= System.today();
                    ev2.Feed_Item_Id__c	= follow.SubscriberId;
                    eventsList.add(ev2);
                }
                
            }
            else if(parentId.startsWith('0TO')){
                //follow a topic
                if(!lEventMap.containsKey('Follow a topic' + '' + followingMember.Id + '' + parentId)){
                    Chatter_Event__c ev1 = new Chatter_Event__c();
                    ev1.member__c = followingMember.Id;
                    ev1.type__c = 'Follow a topic';
                    ev1.Event_Date__c	= System.today();
                    ev1.Feed_Item_Id__c	= parentId;
                    eventsList.add(ev1);
                }
            } 
            
        }
        
        
        if(eventsList.size() > 0){
            insert eventsList;
        }
        */
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('#### finish');
    }
    
}