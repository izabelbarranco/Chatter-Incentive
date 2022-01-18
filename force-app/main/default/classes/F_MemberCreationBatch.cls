global class F_MemberCreationBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator( [SELECT Id, MemberId, Member.Name, Member.Email, CollaborationGroupId, CollaborationGroup.Name,CollaborationGroup.network.name, CollaborationRole FROM CollaborationGroupMember] );
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('##### Execute');
        System.debug('##### List Size ' + scope.Size());
        List<CollaborationGroupMember> collbMemberList = (List<CollaborationGroupMember>) scope;
        List<FieloPLT__Member__c> memberList = new List<FieloPLT__Member__c>();
        
        List<FieloPLT__Program__c> programs = [SELECT Id, Name FROM FieloPLT__Program__c ]; 
        
        for(CollaborationGroupMember collab : collbMemberList){
            for(FieloPLT__Program__c  program : programs){
                if(program.name=='Chatter Incentive'){
                    FieloPLT__Member__c member = new FieloPLT__Member__c();
                    member.FieloPLT__Email__c = collab.Member.Email;
                    member.FieloPLT__Program__c = program.Id;
                    member.FieloPLT__Type__c = 'Employee';
                    member.FieloPLT__User__c = collab.MemberId;
                    member.Group_ID__c = collab.CollaborationGroupId;
                    member.Group_Name__c = collab.CollaborationGroup.Name;
                    member.Name = collab.Member.Name;   
                    member.F_ExternalID__c = collab.MemberId + '-' + collab.CollaborationGroupId;
                    memberList.add(member);
                  }
            }
        }   
        
        try {  
            if(memberList.size()>0)
            upsert memberList F_ExternalID__c;
        }catch (DmlException e) {
            System.debug(e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('#### finish');
    }
    
    
    
    
}