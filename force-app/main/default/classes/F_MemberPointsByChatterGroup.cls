public with sharing class F_MemberPointsByChatterGroup {

    @AuraEnabled(cacheable=true)
    public static FieloPLT__Member__c getMemberByGroup(String groupId) {
        List<FieloPLT__Member__c> members = [SELECT Id, Name, Group_ID__c, FieloPLT__User__c, 
            FieloPLT__Points__c, Group_Name__c, F_Level__c  
            FROM FieloPLT__Member__c
            WHERE Group_ID__c = :groupId
            AND FieloPLT__User__c = :UserInfo.getUserId()];
        return members.isEmpty()?null:members[0];
    }
}