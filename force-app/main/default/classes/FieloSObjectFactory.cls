global with sharing class FieloSObjectFactory {
    
    global static String strNetworkId
	{
		get
		{
			return [SELECT Id FROM Network LIMIT 1][0].Id;
		}
	}

    public static Chatter_Event__c createEvent(Id memberId, Id groupId, String eventType, String groupName) {
        return new Chatter_Event__c(
            member__c = memberId,
            Group_ID__c = groupId,
            type__c = eventType,
            Group_Name__c = groupName
        );
    }
    
    public static Chatter_Event__c createEvent(Id memberId, Id groupId, String eventType, String groupName, Id feedId) {
        return new Chatter_Event__c(
            member__c = memberId,
            Group_ID__c = groupId,
            type__c = eventType,
            Group_Name__c = groupName,
            Feed_Item_Id__c = feedId
        );
    }
    
    public static FieloPLT__Member__c createGeneralMember(String email, String programId, Id userId, String name) {
        return new FieloPLT__Member__c(
            FieloPLT__Email__c = email,
            FieloPLT__Program__c = programId,
            FieloPLT__Type__c = 'Employee',
            FieloPLT__User__c = userId,
            Name = name,
            F_ExternalID__c = userId
        );
    }
    global static Id createTestGroup(Id ownerId, String groupName, List<User> users)
	{
		CollaborationGroup g = new CollaborationGroup(Name = groupName, CollaborationType = 'Public');
		g.OwnerId = ownerId;

		insert g;

		List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();

		for (User user : users)
		{
			CollaborationGroupMember member = new CollaborationGroupMember();
			member.MemberId = user.Id ;
			member.CollaborationGroupId = g.Id ;
			groupMembers.add(member);
		}

		System.assertNotEquals(null, groupMembers);

		insert groupMembers;
		return g.Id ;
	}

	global static Id createTestGroup(String groupName)
	{
		CollaborationGroup myGroup = new CollaborationGroup();
		myGroup.Name               = groupName;
		myGroup.NetworkId          = strNetworkId;
		myGroup.CollaborationType  = 'Public'; //can be 'Public' or 'Private'

		System.assertNotEquals(null, myGroup);

		insert myGroup;
		return myGroup.Id;
	}
    public static User createStandardUserNoContact()//
	{
		List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name = :Peak_Onboarding_TestConstants.COMMUNITY_PROFILE];
		User testUser;
		if (!(standardProfileList == null || standardProfileList.size() == 0))
		{
			Profile standardProfile = standardProfileList[0];
			testUser = new User(Alias = Peak_Onboarding_TestConstants.STANDARD_ALIAS, Email = Peak_Onboarding_TestConstants.STANDARD_EMAIL, EmailEncodingKey = Peak_Onboarding_TestConstants.ENCODING, FirstName = Peak_Onboarding_TestConstants.FIRSTNAME, LastName = Peak_Onboarding_TestConstants.LASTNAME, LanguageLocaleKey = Peak_Onboarding_TestConstants.LOCALE, LocaleSidKey = Peak_Onboarding_TestConstants.LOCALE, ProfileId = standardProfile.Id, TimeZoneSidKey = Peak_Onboarding_TestConstants.TIMEZONE, Username = Peak_Onboarding_TestConstants.STANDARD_USERNAME);
		}

		return testUser;
	}
    
    
}