global class F_BestCommentBatch implements Database.Batchable<sObject>, Schedulable{
    
    global void execute(SchedulableContext sc){
        F_BestCommentBatch bestC = new F_BestCommentBatch();
        database.executeBatch(bestC,200);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator( [SELECT Id, ParentId, Type, CreatedById, CreatedDate, InsertedById, BestCommentId 
                                          FROM FeedItem WHERE BestCommentId != null AND CreatedDate = THIS_FISCAL_QUARTER] );
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('##### Execute');
        System.debug('##### List Size ' + scope.Size());
        List<FeedItem> fItemList = (List<FeedItem>) scope;
        List<FeedItem> fItemListNew = new List<FeedItem>();
        Set<String> fItemSet = new Set<String>();
        
        for( Chatter_Event__c event : [SELECT Id, Feed_Item_Id__c FROM Chatter_Event__c
                                               WHERE Feed_Item_Id__c != '' AND type__c = 'Your answer is marked as best'] ){
                                                 fItemSet.add(event.Feed_Item_Id__c);
                                                   System.debug('fitemset: '+event.Feed_Item_Id__c);
                                               }
        
        System.debug('##### fItemSet Size ' + fItemSet.Size());
        
        for(FeedItem fItem : fItemList){
            boolean valid = true;
            
            for(String s: fItemSet){
                if(fItem.Id == s){
                    valid = false;
                }
            }
            
            if(valid){
                fItemListNew.add(fItem);
            }
            
        }
        
        System.debug('##### fItemListNew Size ' + fItemListNew.Size());
        if(fItemListNew.size() > 0){
            FieloFeedItemService service = new FieloFeedItemService();
            service.fieloEventBestAnswer(fItemListNew);
        }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        System.debug('#### finish');
    }

}