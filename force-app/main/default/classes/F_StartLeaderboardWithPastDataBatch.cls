global class F_StartLeaderboardWithPastDataBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator( [SELECT Id, FieloPLT__Member__c, FieloPLT__Member__r.FieloPLT__User__c, Chatter_Event__c,
                                          Chatter_Event__r.type__c, FieloPLT__Member__r.Group_ID__c, FieloPLT__Points__c, FieloPLT__Date__c 
                                          FROM FieloPLT__Transaction__c WHERE FieloPLT__Date__c = THIS_FISCAL_QUARTER
                                          AND FieloPLT__IsProcessed__c = true AND FieloPLT__Points__c != NULL ORDER BY FieloPLT__Date__c] );
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('##### Execute');
        System.debug('##### List Size ' + scope.Size());
        List<FieloPLT__Transaction__c> transactionList = (List<FieloPLT__Transaction__c>) scope;
        List<F_Leaderboard__c> lBoardInsert = new List<F_Leaderboard__c>();
        List<F_Leaderboard__c> lBoardUpdate = new List<F_Leaderboard__c>();
        Set<Id> memberSet = new Set<Id>();
        
        for(FieloPLT__Transaction__c t : transactionList){
            memberSet.add(t.FieloPLT__Member__c);
        }
        
        List<Period> pList = [SELECT Id, Type, StartDate, EndDate FROM Period WHERE StartDate = THIS_FISCAL_QUARTER AND Type != 'Year'];
        
        Map<String,F_Leaderboard__c> lBoardMap = new Map<String,F_Leaderboard__c>();
        for(F_Leaderboard__c lBoard :[SELECT Id, F_User__c, F_ChatterGroupId__c, EndDate__c,Member__c, Points__c, Position__c,
                                          StartDate__c, Type__c, Number_Answers__c, Number_Best_Answers__c, Number_Blogs__c,
                                          Number_Comments__c, Number_Comments_Rece__c, Number_Followers__c, Number_Ideas__c,
                                          Number_Likes_given__c, Number_Likes_received__c, Number_Marking_Answers_as_best__c,
                                          Number_Mentions_given__c, Number_Mentions_received__c, Number_Person_followed__c, Number_Posts__c,
                                          Number_Posts_Shared__c, Number_Questions__c, Number_Questions_answered__c, Number_Topics_Followed__c
                                          FROM F_Leaderboard__c WHERE Member__c IN :memberSet]) {
                                              lBoardMap.put(lBoard.Member__c + '' + lBoard.Type__c + '' + lBoard.StartDate__c, lBoard);
                                          }
        system.debug('lBoardMap: '+lBoardMap);
        
        for(FieloPLT__Transaction__c t : transactionList){
            System.debug('#### Transaction  ' + t );
            Decimal quarterPoints = 0;
            F_Leaderboard__c tempQuarterLeaderboard = new F_Leaderboard__c();
            
            //Giving points only to the Quarter Records
            for(Period p : pList){
                if(t.FieloPLT__Date__c >= p.StartDate && t.FieloPLT__Date__c <= p.EndDate && p.Type == 'Quarter'){
                    System.debug('#### Period ' + p );
                    
                    if(lBoardMap.containsKey(t.FieloPLT__Member__c + '' + p.Type + '' + p.StartDate)){
                        F_Leaderboard__c lBoard = lBoardMap.get(t.FieloPLT__Member__c + '' + p.Type + '' + p.StartDate);
                        lboard.Points__c += t.FieloPLT__Points__c;
                        quarterPoints = lboard.Points__c;
                        
                        if(t.Chatter_Event__c != null){
                            if(t.Chatter_Event__r.type__c == 'Your answer is marked as best'){
								lBoard.Number_Best_Answers__c = lBoard.Number_Best_Answers__c == null ? 1 : lBoard.Number_Best_Answers__c + 1;
                                tempQuarterLeaderboard.Number_Best_Answers__c = lBoard.Number_Best_Answers__c;
                            } else if(t.Chatter_Event__r.type__c == 'Receive a like'){
                                lBoard.Number_Likes_received__c = lBoard.Number_Likes_received__c == null ? 1 : lBoard.Number_Likes_received__c + 1;
                                tempQuarterLeaderboard.Number_Likes_received__c = lBoard.Number_Likes_received__c;
                            } else if(t.Chatter_Event__r.type__c == 'Write a post'){
                                lBoard.Number_Posts__c = lBoard.Number_Posts__c == null ? 1 : lBoard.Number_Posts__c + 1;
                                tempQuarterLeaderboard.Number_Posts__c = lBoard.Number_Posts__c;
                            }
                        }
                        
                        lBoardUpdate.add(lboard);
                    }
                    else{
                        F_Leaderboard__c lBoard = new F_Leaderboard__c();
                        lBoard.Points__c = t.FieloPLT__Points__c;
                        lBoard.EndDate__c = p.EndDate;
                        lBoard.StartDate__c = p.StartDate;
                        lBoard.Type__c = p.Type;
                        lboard.F_Type__c = 'Chatter Group';
                        lBoard.F_User__c = t.FieloPLT__Member__r.FieloPLT__User__c;
                        lBoard.F_ChatterGroupId__c = t.FieloPLT__Member__r.Group_ID__c;
                        lBoard.Member__c = t.FieloPLT__Member__c;
                        quarterPoints = lboard.Points__c;
                        if(t.Chatter_Event__c != null){
                            if(t.Chatter_Event__r.type__c == 'Your answer is marked as best'){
                                lBoard.Number_Best_Answers__c = 1;
                                tempQuarterLeaderboard.Number_Best_Answers__c = lBoard.Number_Best_Answers__c;
                            } else if(t.Chatter_Event__r.type__c == 'Receive a like'){
                                lBoard.Number_Likes_received__c = 1;
                                tempQuarterLeaderboard.Number_Likes_received__c = lBoard.Number_Likes_received__c;
                            }else if(t.Chatter_Event__r.type__c == 'Write a post'){
                                lBoard.Number_Posts__c = 1;
                                tempQuarterLeaderboard.Number_Posts__c = lBoard.Number_Posts__c;
                            }
                        }
                        lBoardInsert.add(lboard);
                        lBoardMap.put(lBoard.Member__c + '' + lBoard.Type__c + '' + lBoard.StartDate__c, lBoard);
                    }
                }
            }
            
            //Giving points to the Week and Month Records
            for(Period p : pList){
                if(t.FieloPLT__Date__c >= p.StartDate && t.FieloPLT__Date__c <= p.EndDate && p.Type != 'Quarter'){
                    System.debug('#### Period ' + p );
                    
                    if(lBoardMap.containsKey(t.FieloPLT__Member__c + '' + p.Type + '' + p.StartDate)){
                        F_Leaderboard__c lBoard = lBoardMap.get(t.FieloPLT__Member__c + '' + p.Type + '' + p.StartDate);
                        lboard.Points__c = quarterPoints;
                        if(t.Chatter_Event__c != null){
                            if(t.Chatter_Event__r.type__c == 'Your answer is marked as best'){
                                lBoard.Number_Best_Answers__c = tempQuarterLeaderboard.Number_Best_Answers__c;
                            } else if(t.Chatter_Event__r.type__c == 'Receive a like'){
                                lBoard.Number_Likes_received__c = tempQuarterLeaderboard.Number_Likes_received__c;
                            } else if(t.Chatter_Event__r.type__c == 'Write a post'){
                                lBoard.Number_Posts__c = tempQuarterLeaderboard.Number_Posts__c;
                            }
                        }
                        lBoardUpdate.add(lboard);
                    }
                    else{
                        F_Leaderboard__c lBoard = new F_Leaderboard__c();
                        lBoard.Points__c = quarterPoints;
                        lBoard.EndDate__c = p.EndDate;
                        lBoard.StartDate__c = p.StartDate;
                        lBoard.Type__c = p.Type;
                        lboard.F_Type__c = 'Chatter Group';
                        lBoard.F_User__c = t.FieloPLT__Member__r.FieloPLT__User__c;
                        lBoard.F_ChatterGroupId__c = t.FieloPLT__Member__r.Group_ID__c;
                        lBoard.Member__c = t.FieloPLT__Member__c;
                        if(t.Chatter_Event__c != null){
                            if(t.Chatter_Event__r.type__c == 'Your answer is marked as best'){
                                lBoard.Number_Best_Answers__c = tempQuarterLeaderboard.Number_Best_Answers__c;
                            } else if(t.Chatter_Event__r.type__c == 'Receive a like'){
                                lBoard.Number_Likes_received__c = tempQuarterLeaderboard.Number_Likes_received__c;
                            } else if(t.Chatter_Event__r.type__c == 'Write a post'){
                                lBoard.Number_Posts__c = tempQuarterLeaderboard.Number_Posts__c;
                            }
                        }
                        lBoardInsert.add(lboard);
                        lBoardMap.put(lBoard.Member__c + '' + lBoard.Type__c + '' + lBoard.StartDate__c, lBoard);
                    }
                }
            }
        }
        
        System.debug('#### lBoardInsert.size() ' + lBoardInsert.size());
        System.debug('#### lBoardUpdate.size() ' + lBoardUpdate.size());
        
        if(lBoardInsert.size() > 0){
            insert lBoardInsert;
        }
        
        if(lBoardUpdate.size() > 0){
            //Removing duplicate Ids 
            Set<F_Leaderboard__c> lBoardSet = new Set<F_Leaderboard__c>();
            for (Integer i = 0; i < lBoardUpdate.size(); i++){
                lBoardSet.add(lBoardUpdate[i]);
            }
            System.debug('##### lBoardSet.size() ' + lBoardSet.size());
            
            update new List<F_Leaderboard__c>(lBoardSet);
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('#### finish');
        List<Period> pList = [SELECT Id, Type, StartDate, EndDate FROM Period WHERE StartDate = THIS_FISCAL_QUARTER AND Type != 'Year'];
        List<CollaborationGroup> cgGroupList = [SELECT Id, Name, NetworkId, CollaborationType, MemberCount FROM CollaborationGroup WHERE NetworkId != '' AND MemberCount > 0];
        
        List<String> groupCheck = new List<String>();
        for(CollaborationGroup cgGroup : cgGroupList){
            for(Period p : pList){
                groupCheck.add(cgGroup.Id + '@' + p.Type + '@' + p.StartDate);
            }  
        }
        
        System.debug('groupCheck.size() ' + groupCheck.size());
        
        F_LeaderboardOrderBatch lBoard = new F_LeaderboardOrderBatch(0, groupCheck);
        database.executeBatch(lBoard); 
    }
    
}