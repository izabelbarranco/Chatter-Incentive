global class F_ExpireTotalPointsBatch implements Database.Batchable<sObject> {

    global Iterable<sObject> start(Database.BatchableContext bc) {

        return Database.getQueryLocator([SELECT Id From FieloPLT__Member__c WHERE FieloPLT__Points__c > 0]);        

    }
    global void execute(Database.BatchableContext bc, List<FieloPLT__Member__c> records){

        Set<Id> memberIds = new Set<Id>();
        for(FieloPLT__Member__c m : records){
            memberIds.add(m.Id);
        }

        FieloPLT.MemberService.expireTotalPoints(memberIds);

    }    
    global void finish(Database.BatchableContext bc){

        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        System.debug(job);
        //EmailUtils.sendMessage(job, 'Job finished!');

    }    
}