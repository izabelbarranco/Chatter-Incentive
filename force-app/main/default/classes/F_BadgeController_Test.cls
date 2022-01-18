@isTest
public class F_BadgeController_Test {
    @isTest
    static void testGetBadgesList(){
        Id userID = UserInfo.getUserId();
        Test.startTest();
        F_badgecontroller.getBadgesList(userID);
        Test.stopTest();
    }
}