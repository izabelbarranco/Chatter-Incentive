public with sharing class F_PurgeBatch implements Database.Batchable<sObject>, Database.Stateful{
        
    private Integer currentBatch;


    public F_PurgeBatch(){
        currentBatch = 0;
    }

    public F_PurgeBatch(integer current){
        currentBatch = current;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        string q;
        if(currentBatch == 0)
        {
			q = 'SELECT ID FROM Chatter_Event__C WHERE CreatedDate = LAST_FISCAL_QUARTER';
        }
        if(currentBatch == 1)
        {
			q = 'Select ID FROM FieloPLT__Point__c WHERE CreatedDate = LAST_FISCAL_QUARTER';
        }
        if(currentBatch == 2)
        {
			q = 'Select ID FROM FieloPLT__Transaction__c WHERE CreatedDate = LAST_FISCAL_QUARTER';
        }
        if(currentBatch == 3)
        {
			q = 'Select ID FROM F_Leaderboard__c WHERE CreatedDate = LAST_FISCAL_QUARTER AND Type__c != \'Quarter\' ';
        }
        return Database.getQueryLocator(q);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
			delete scope;
    }

    public void finish(Database.BatchableContext BC){
            system.debug('####### FINISH #######');
    }


}