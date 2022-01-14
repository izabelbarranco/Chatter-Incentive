public with sharing class FieloCommunityActivityDetailsController {

    @AuraEnabled(cacheable=true)
    public static List<MemberExtractWrapper> getMemberExtractByGroup(String groupId) {
        List<MemberExtractWrapper> memberExtractWrLst= new List<MemberExtractWrapper>();
        for(AggregateResult lAr :[SELECT Chatter_Event__r.Type__c typeEv, COUNT(Id) countPt, SUM(FieloPLT__Points__c) totalPoints
                FROM FieloPLT__Transaction__c
                WHERE Chatter_Event__c != null 
                AND Chatter_Event__r.Group_ID__c = :groupId
                AND FieloPLT__Member__r.FieloPLT__User__c = :UserInfo.getUserId()
                GROUP BY Chatter_Event__r.Type__c]) {
            memberExtractWrLst.add(
                new MemberExtractWrapper(
                    String.valueOf(lAr.get('typeEv')),
                    Integer.valueOf(lAr.get('countPt')),
                    (Decimal)(lAr.get('totalPoints'))
                )
            );
        }
        memberExtractWrLst.sort();
        return memberExtractWrLst;
    }

    public class MemberExtractWrapper implements Comparable {
        @AuraEnabled public String activity;
        @AuraEnabled public Integer count;
        @AuraEnabled public Decimal pointsEarned;

        public MemberExtractWrapper(String aActivity, Integer aCount, Decimal aPointsEarned) {
            this.activity = aActivity;
            this.count = aCount;
            this.pointsEarned = aPointsEarned;
        }

        public Integer compareTo(Object compareTo) {
            MemberExtractWrapper compareToAct = (MemberExtractWrapper)compareTo;
            if (activity == compareToAct.activity) return 0;
            if (activity > compareToAct.activity) return 1;
            return -1;        
        }
    }
}