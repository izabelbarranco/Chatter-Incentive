public without sharing class F_LeaderboardList {
    @AuraEnabled(Cacheable = true )
    public static String getLeaderboardList(string type, String groupID, integer position){
        System.debug('#### groupID ' + groupID);
        System.debug('#### type ' + type);
        List<F_Leaderboard__c> LeaderboardList = new List<F_Leaderboard__c>();
        integer half = (position -1)/2;
        id userID = UserInfo.getUserId();
        FieloPLT__Member__c cMember = [select ID from FieloPLT__Member__C where FieloPLT__User__C =: userID and Group_Id__C =: groupID LIMIT 1];
        System.debug('#### member ' + cMember);
        List<F_Leaderboard__c> currentMemberList = [SELECT Id, Type__c, StartDate__c, EndDate__c, Points__c, Position__c 
                                                    FROM F_Leaderboard__c 
                                                    WHERE Member__c =: cMember.id AND Type__c =: type and StartDate__c = THIS_FISCAL_QUARTER];
        
        System.debug('#### currentMemberList ' + currentMemberList);
        if(currentMemberList.size() > 0){
            if (currentMemberList[0].Position__C <= position){ 
                LeaderboardList = [SELECT Id, Member__c, Member__r.Name, Member__r.FieloPLT__User__r.FullPhotoUrl, Type__c, StartDate__c, EndDate__c, Points__c, Position__c FROM F_Leaderboard__c
                                   WHERE Position__c <= :position AND F_ChatterGroupId__c =:groupID AND type__c =: type AND StartDate__c = THIS_FISCAL_QUARTER ORDER BY position__c ];
            }
            else{
                F_Leaderboard__c lastposition = [SELECT position__c FROM F_Leaderboard__c where type__c =:type
                                                     AND member__r.Group_ID__c =: groupID ORDER BY position__c DESC LIMIT 1];
                if(lastposition.position__c - half >= currentMemberList[0].Position__C){
                    LeaderboardList = [SELECT Id, Member__c, Member__r.Name, Member__r.FieloPLT__User__r.FullPhotoUrl, Type__c, StartDate__c, EndDate__c, Points__c, Position__c FROM F_Leaderboard__c
                                       WHERE Position__c >= :currentMemberList[0].Position__C -2 AND Position__c <= :currentMemberList[0].Position__C +2 AND F_ChatterGroupId__c =:groupID AND type__c =: type AND StartDate__c = THIS_FISCAL_QUARTER ORDER BY position__c LIMIT :position];
                }
                else{
                    LeaderboardList = [SELECT Id, Member__c, Member__r.Name, Member__r.FieloPLT__User__r.FullPhotoUrl, Type__c, StartDate__c, EndDate__c, Points__c, Position__c FROM F_Leaderboard__c
                    WHERE F_ChatterGroupId__c =:groupID and type__c =: type AND StartDate__c = THIS_FISCAL_QUARTER AND position__c >= :currentMemberList[0].Position__C-position+1 ORDER BY position__c LIMIT :position];
                }
            }
        } else{
            LeaderboardList = [SELECT Id, Member__c, Member__r.Name, Member__r.FieloPLT__User__r.FullPhotoUrl, Type__c, StartDate__c, EndDate__c, Points__c, Position__c FROM F_Leaderboard__c
                               WHERE F_ChatterGroupId__c =:groupID and type__c =: type AND StartDate__c = THIS_FISCAL_QUARTER ORDER BY position__c LIMIT 5];
            
        }                           
        
        
        System.debug('#### LeaderboardList ' + LeaderboardList);
        
        return JSON.serialize(LeaderboardList);
    }
    
    
    @AuraEnabled(Cacheable = true)
    public static string getCurrentMember(string groupID){
        id userID = UserInfo.getUserId();
        FieloPLT__Member__c cMember = [select ID from FieloPLT__Member__C where FieloPLT__User__c =: userID and Group_Id__c =: groupID];
        return cMember.ID;
    }
    
    @AuraEnabled(Cacheable = true )
    public static Map<String,List<Period>> getPeriods(){
        
        Map<String,List<Period>> pMap = new Map<String,List<Period>>();
        for(Period p : [SELECT StartDate, EndDate, Type FROM Period WHERE StartDate = THIS_FISCAL_QUARTER and type != 'year']){
            System.debug('#### Period ' + p);
            if (pMap.Containskey(p.type)){
                pMap.get(p.type).add(p);
            } 
            else {
                List<Period> pList = new List<Period>();
                pList.add(p);
                pMap.put(p.Type, pList);
            }
            
        }
        
        system.debug(pMap);
        
        
        return pMap;    
    }
    
    @AuraEnabled(Cacheable = true)
    public static String getGroups(){
        
        user curUser = [select id, CX_Role__c from User where Id =: UserInfo.getUserId()];
        Set<id> groupIds = new Set<id>();
        
        //List<FieloPLT__member__c> fMember = [Select Group_id__C from FieloPLT__member__c where fieloPLT__user__c =: curUser.id];
        
        for (FieloPLT__member__c i : [Select Group_id__C from FieloPLT__member__c where fieloPLT__user__c =: curUser.id]){
            groupIds.add(i.group_id__c);
        }
        List<F_GroupWrapper> allGroups = new List<F_GroupWrapper>();
        for(CollaborationGroup i : [Select Id, Name from CollaborationGroup where id IN : groupIds]){
            boolean isPrimary = false;
            if (i.name == curUser.CX_Role__c){
                isPrimary = true;
            }
            F_GroupWrapper nGroupw = New F_GroupWrapper(i, isPrimary);
            allGroups.add(nGroupw);
        }
        
        return JSON.serialize(allGroups);
    }
    
    @AuraEnabled(Cacheable = true)
    public static FieloPLT__Member__c getCurrentLevel(string memberID){
        
        FieloPLT__Member__c CurrentlevelMember = [SELECT FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.Name, FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.FieloPLT__Order__c FROM FieloPLT__Member__c WHERE id =: memberID limit 1];
        
        
        return CurrentlevelMember;
        // SELECT FieloPLT__Order__c,name  FROM FieloPLT__Level__c
    }

    
    @AuraEnabled(Cacheable = true)
    public static List<FieloPLT__Level__c> getOrder(){
        
        /*
        FieloPLT__Member__c CurrentlevelMember = [SELECT FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.Name, FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.FieloPLT__Order__c FROM FieloPLT__Member__c WHERE id =: memberID limit 1];
        Decimal Order = CurrentlevelMember.FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.FieloPLT__Order__c;
        List<FieloPLT__Level__c> NextLevel = [SELECT name  FROM FieloPLT__Level__c WHERE FieloPLT__Order__c =: Order-1];
        */
		
        List<FieloPLT__Level__c> Order = [SELECT FieloPLT__Order__c,name FROM FieloPLT__Level__c ORDER BY FieloPLT__Order__c];


        return Order;
         
    }

    @AuraEnabled
    public static Decimal getPointsForUser(){
        Decimal totalPoints = 0;
        for(F_Leaderboard__c i : [SELECT Points__c FROM F_Leaderboard__c WHERE Member__r.FieloPLT__User__c =: Userinfo.getUserid() AND Type__C = 'Quarter']){
            totalPoints = totalPoints + i.Points__c;
        }
        return totalPoints;
    }

    @AuraEnabled
    public static map<string, integer> getFields(List<String> fieldsToBeSearched){
        integer value;
        List<String> originalfields = new List<String>();
        Map<string, integer> databaseresult = new Map<string, Integer>();
        for(Integer i = 0; i < fieldsToBeSearched.size(); i++){
            originalfields.add(fieldstobesearched[i]);
            fieldsToBeSearched[i] = 'Sum(' + fieldsToBeSearched[i] + ')';
        }
        id userid = userinfo.getuserid();

		string joinedfields = string.join(fieldsToBeSearched, ', ');
        string q = 'select ' + joinedfields + ' FROM F_Leaderboard__c WHERE Member__r.FieloPLT__User__c =: userid AND Type__C = \'Quarter\' AND StartDate__c = THIS_FISCAL_QUARTER';
        Aggregateresult result = database.query(q);
        for (integer i =0; i< originalfields.size(); i++){
            if (integer.valueof(result.get('expr' + i)) == null){
                value = 0;
            }
            else{
                value = integer.valueof(result.get('expr' + i));
            }
            databaseresult.put(originalfields[i], value);
        }

        return databaseresult;
    }  
}