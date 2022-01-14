@isTest
public class F_ExpireTotalPointsBatchTest {
    
    @testSetup 
    static void setup() {
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='Fielo Essentials Admin' Limit 1];
        adminUser.userRoleId = '00EE0000000GdeUMAS';
        update adminUser;
        system.runAs(adminUser){
        Account portalAccount = new Account();
        portalAccount.Name = 'TestAccount';
        insert portalAccount;
        }
        hiddenMethod();
    }
    @future
    private static void hiddenMethod(){
        Recordtype recordtype = [Select ID from Recordtype where DeveloperName ='Contact' LIMIT 1];
        account portalAccount = [select id from account where name = 'TestAccount'];

        Contact contact1 = new Contact();
        contact1.FirstName = 'Test';
        contact1.Lastname = 'McTesty';
        contact1.AccountId = portalAccount.Id;
        contact1.Email = 'test@fielo.com';
        contact1.RecordTypeId = recordtype.Id;
        insert contact1;         
        
        Profile prof = F_SObjectForTest.getProfile('Customer Community User');
        User u = F_SObjectForTest.getUser(prof.Id,'tst', contact1.Id);
        insert u;
      
        FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
        insert program;
        
        FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, u.Id, contact1.Id);
        insert member;

        FieloPLT__Transaction__c newtransaction =  new FieloPLT__Transaction__c();
        newtransaction.FieloPLT__Points__c = 15;
        newtransaction.FieloPLT__Member__c = member.id;
        newtransaction.FieloPLT__SkipEngine__c = true;
        newtransaction.FieloPLT__Type__c = 'Adjustment';
        newtransaction.FieloPLT__Value__c = 0;
        newtransaction.FieloPLT__Reason__c = 'adjustment1';
        newtransaction.FieloPLT__IsAdjust__c = true;

        insert newtransaction;
    }

     @isTest
    static void test1(){
        FieloPLT__Member__c member = [select id, FieloPLT__Points__c from FieloPLT__Member__c];
        system.debug(member);
        Test.startTest();
            F_ExpireTotalPointsBatch btch = new F_ExpireTotalPointsBatch();
            Database.executeBatch(btch, 1);
        Test.stopTest();
    }
    
    // @isTest
    // static void test2(){

    //     Test.startTest();
    //         F_ExpireTotalPointsBatch btch = new F_ExpireTotalPointsBatch();
    //         Database.executeBatch(btch, 1);
    //     Test.stopTest();
    // }
}