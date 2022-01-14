@isTest
public class FieloFeedItemService_Test {

    @IsTest(SeeAllData=true)
    static void FieloEventForumPostTest(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        adminUser.userRoleId = testRole.id;


        permissionset ps = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        insert new PermissionSetAssignment(AssigneeId = adminUser.id, PermissionSetId = ps.Id);
        
        List<FeedItem> feedlist = [select id, parentId, CreatedById, Type, Title, Body, status from FeedItem limit 100];
        
        FieloPLT.CacheAPI.enableCacheAccess(false);
        
        system.runAs(adminUser){
            FieloFeedItemService FPTest = new FieloFeedItemService();
            
            test.startTest();
    
            FPTest.fieloEventForumPost(feedlist);
            
            test.stopTest();
        }
    }
    
    @IsTest(SeeAllData=True)
    static void fieloEventBestAnswerTest(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        adminUser.userRoleId = testRole.id;

        update adminUser;

        permissionset ps = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        insert new PermissionSetAssignment(AssigneeId = adminUser.id, PermissionSetId = ps.Id);

        List<FeedItem> feedlist = new list<FeedItem>(); 
        feedlist = [select id, parentId, CreatedById, BestCommentId, Type, Title, Body, status from FeedItem limit 100];
        
        FieloPLT.CacheAPI.enableCacheAccess(false);
        system.runAs(adminUser){
            FieloFeedItemService FPTest = new FieloFeedItemService();
            
            test.startTest();
            
            FPTest.fieloEventBestAnswer(feedlist);
            
            test.stopTest();
       }
    }
    
    @IsTest(SeeAllData=True)
    static void fieloSharePostTest(){
        userRole testRole = [select id from userrole where name = 'CEO' limit 1];
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        adminUser.userRoleId = testRole.id;

        update adminUser;

        permissionset ps = [SELECT Id FROM PermissionSet WHERE Name = 'FieloPLTAdmin'];
        insert new PermissionSetAssignment(AssigneeId = adminUser.id, PermissionSetId = ps.Id);

        List<FeedItem> feedlist = new list<FeedItem>(); 
        feedlist = [select id, parentId, Parent.name, CreatedById, InsertedById, Type, Title, Body, status from FeedItem limit 100];
        
        FieloPLT.CacheAPI.enableCacheAccess(false);
        system.runAs(adminUser){
            FieloFeedItemService FPTest = new FieloFeedItemService();
            
            test.startTest();
            
            FPTest.fieloSharePost(feedlist);
            
            test.stopTest();
        }
    }
}