/*
 * Copyright (c) 2019. 7Summits Inc. All rights reserved.
 *
 */

// ===================
// Share general utility methods
// ===================
global with sharing class Peak_Onboarding_Utils
{
	// Return true/false to determine guest user
	global static Boolean isGuestUser()
	{
		Boolean isGuest = false;
		if (UserInfo.getUserType() == 'Guest' || UserInfo.getUserName() == Peak_Onboarding_TestConstants.GUEST_USERNAME)
		{
			isGuest = true;
		}
		return isGuest;
	}

	// Get the site prefix
	global static String getSitePrefix()
	{
		return System.Site.getPathPrefix();
	}

	// Get picklist values for any object, any field
	public static List<String> getPicklistValues(String ObjectApi_name, String Field_name)
	{
		// Thanks http://salesforce.stackexchange.com/questions/4992/how-to-get-a-picklist-all-values-in-apex-controller
		List<String> lstPickvals = new List<String>();
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
		SObject Object_name = targetType.newSObject();
		Schema.SObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
		List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPicklistValues(); //grab the list of picklist values for the passed field on the sobject
		for (Schema.PicklistEntry a : pick_list_values)
		{ //for all values in the picklist list
			lstPickvals.add(a.getValue());//add the value  to our final list
		}

		return lstPickvals;
	}

	// Build string from list
	public static String buildStringFromList(List<String> sourceList)
	{
		String stringOutput = '';
		for (String thisString : sourceList)
		{
			stringOutput += (stringOutput == '' ? '' : ', ') + thisString;
		}
		return stringOutput;
	}

	// Build comma list string from a set
	public static String buildStringFromSet(Set<String> sourceSet)
	{
		List<String> sourceList = new List<String>();
		sourceList.addAll(sourceSet);
		return buildStringFromList(sourceList);
	}


	// Get User
	public static User getUser()
	{
		return getUser(UserInfo.getUserId());
	}
	// Get User
	public static User getUser(Id userId)
	{
		// BannerPhotoUrl, IsProfilePhotoActive
		User user;

		List<User> userList =
		[
			SELECT
				Id, Email,PostalCode
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];

		if (!Peak_Onboarding_Utils.isNullOrEmpty(userList))
		{
			user = userList[0];
		}

		return user;
	}

	public static Boolean isNullOrEmpty(List<Object> objectList)
	{
		if (objectList == null || objectList.size() == 0)
		{
			return true;
		}
		return false;
	}

	public static List<String> createListFromMultiPicklist(String multiPicklistValue)
	{

		List<String> multiPicklistValueList = multiPicklistValue.split(';');
		return multiPicklistValueList;
	}

	public static Boolean doesStringContainListItem(List<String> compareList, String targetString)
	{

		for (String compareString : compareList)
		{

			//If list contains target string, return true
			if (targetString.contains(compareString))
			{
				return true;
			}
		}
		return false;
	}

	// Get the fieldmap for an object
	public static Map<String, Schema.SObjectField> getFieldSchema(String objectName)
	{
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType schema = schemaMap.get(objectName);
		Map<String, Schema.SObjectField> fieldMap = schema.getDescribe().fields.getMap();

		return fieldMap;
	}

	/*
		Take a list of objects, get their IDs. Handy for getting a list of Objects than using their IDs in a where clause of another query
		List<SObject> orderRoles = some query;
		Set<Id> contactIds = new Set<Id> (Peak_Onboarding_Utils.toIds(orderRoles , 'Contact__c')); This would get Ids from the Contact__c field of our collection.
		new query - select something from something where someID in : contactIds
	 */
	public static List<Id> toIds(List<SObject> records, final String fieldName)
	{
		List<Id> ids = new List<Id>();
		for (SObject record : records)
		{
			Id idVal = (Id) record.get(fieldName);
			ids.add(idVal);
		}
		return ids;
	}

	// Replace the space in the input string with a underscore
	public static String replaceSpace(String inputString)
	{
		return inputString.replaceAll('\\s+', '_');
	}
}