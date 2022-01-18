@isTest
public class F_ExpireTotalPointsBatchTest {
    
    @testSetup 
    static void setup() {
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        //update adminUser;
        system.runAs(adminUser){
        Account portalAccount = new Account();
        portalAccount.Name = 'TestAccount';
        insert portalAccount;
        }
        hiddenMethod();
    }
    @future
    private static void hiddenMethod(){         
        
       FieloPLT__Program__c program = F_SObjectForTest.getProgram('Test Program');
        insert program;
        
        FieloPLT__Member__c member = F_SObjectForTest.getMember('Test Member', program.Id, UserInfo.getUserId());
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