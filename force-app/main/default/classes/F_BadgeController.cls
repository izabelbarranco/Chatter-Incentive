public with sharing class F_BadgeController {


    @AuraEnabled()
    public static List<AggregateResult > getBadgesList(string userID){
        List<FieloPLT__Member__c> memberInfo = [SELECT ID From FIELOPLT__MEMBER__C WHERE FIELOPLT__USER__C =:userID];

        List<AggregateResult> badgeMemberOrig = [SELECT FIELOPLT__Badge__r.FieloPLT__ExternalURL__C, fieloplt__badge__r.id, FIELOPLT__Badge__r.name, Count(FIELOPLT__Badge__r.LastModifiedDate) from FieloPLT__BadgeMember__c
         WHERE FieloPLT__Badge__r.name != null Group BY FIELOPLT__Badge__r.name, FIELOPLT__Badge__r.FieloPLT__ExternalURL__C, fieloPLT__badge__r.id ORDER BY Min(CreatedDate)];
        return badgeMemberOrig;
    }
}