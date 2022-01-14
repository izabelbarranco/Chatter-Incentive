global class F_LeaderboardOrderBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global Integer position;
    public Integer groupIndex;
    public Id groupId;
    public date startDate;
    public string type;
    public List<String> groupCheck;
    
    public F_LeaderboardOrderBatch(Integer index, list<String> groupCheck){
        groupIndex = index;
        this.groupCheck = groupCheck;
        position = 0;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String groupToCheck = groupCheck[groupIndex];
		System.debug('#### groupIndex: ' + groupIndex);
		System.debug('#### Gonna order this list: ' + groupToCheck);
        
		List<String> splitList = groupToCheck.split('@');
        groupId = splitList[0];
        type = splitList[1];
        startDate = Date.valueOf(splitList[2]);
        
        return Database.getQueryLocator( [SELECT Id, F_User__c, F_ChatterGroupId__c, EndDate__c,Member__c, Points__c, Position__c,
                                          StartDate__c, Type__c FROM F_Leaderboard__c WHERE StartDate__c = :startDate
                                          AND F_ChatterGroupId__c = :groupId AND Type__c = :type ORDER BY Points__c DESC, LastModifiedPoints__c] );
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('##### Execute');
        System.debug('##### List Size ' + scope.Size());
        List<F_Leaderboard__c> leaderboardList = (List<F_Leaderboard__c>) scope;
        List<F_Leaderboard__c> lBoardListUpdate = new List<F_Leaderboard__c>();
        
        for(F_Leaderboard__c lBoardValue : leaderboardList ){
            System.debug('###### position ' + (position+1));
            lBoardValue.Position__c = position+1;
            position++;
            lBoardListUpdate.add(lBoardValue);
        }
        update lBoardListUpdate;
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('##### finish');
        
        if(groupIndex+1 < groupCheck.size()){
            System.debug('#### Gonna call this index: ' + (groupIndex+1));
            
            F_LeaderboardOrderBatch lBoard = new F_LeaderboardOrderBatch(groupIndex+1, groupCheck);
            database.executeBatch(lBoard);
        }else{
            System.debug('#### End of all order');
        }
        
    }
    
}