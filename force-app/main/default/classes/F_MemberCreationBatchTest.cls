@isTest
private class F_MemberCreationBatchTest {
	@testSetup
    static void setup(){
        List <Network> testnetworkList = [SELECT Id, Name FROM Network WHERE Name='Test Chatter'];
		Id networkId = testnetworkList[0].Id;

		User testUser = FieloSObjectFactory.createStandardUserNoContact();
		insert testUser;
       
        
        FieloPLT__Program__c program = F_SObjectForTest.getProgram('Chatter Incentive');
        insert program;
        
		List <CollaborationGroup> testGroups = new List <CollaborationGroup>();
		for (Integer i = 0; i < 1; i++){
			CollaborationGroup colGroup = new CollaborationGroup(
				Name = 'Test Chatter Group' + i,
				CollaborationType = 'Public',
				CanHaveGuests = false,
				NetworkId = networkId);
			testGroups.add(colGroup);
		}

		insert testGroups;
        
		List <Id> groupIds = new List <Id>();
        for(Integer i = 0; i < 1; i++){
            for (CollaborationGroup grp : [SELECT Id FROM CollaborationGroup WHERE Name = 'Test Chatter Group0']){
                groupIds.add(grp.Id);
            }
            
            CollaborationGroupMember member = new CollaborationGroupMember(CollaborationGroupId = groupIds[0], MemberId = testUser.Id);
            insert member;
            
        }
            
		
    }
    
    @isTest static void test() {
        Test.startTest();
        F_MemberCreationBatch mcb = new F_MemberCreationBatch();
        Id batchId = Database.executeBatch(mcb);
        Test.stopTest();
    }
}