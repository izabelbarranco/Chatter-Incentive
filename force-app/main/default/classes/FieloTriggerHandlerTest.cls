@isTest
public class FieloTriggerHandlerTest {
    @IsTest
    static void testSetContext(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.BEFORE_INSERT);
        Test.startTest();
        System.assertEquals(handler.TriggerContext.Name(), System.TriggerOperation.BEFORE_INSERT.Name());
        Test.stopTest();
        
    }
    static testMethod void testOnBeforeInsert(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.BEFORE_INSERT);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testOnAfterInsert(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.AFTER_INSERT);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testOnBeforeUpdate(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.BEFORE_UPDATE);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testOnAfterUpdate(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.AFTER_UPDATE);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testOnBeforeDelete(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.BEFORE_DELETE);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testOnAfterDelete(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.AFTER_DELETE);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testOnAfterUnDelete(){
        TestTriggerHandler handler = new TestTriggerHandler();
        handler.setContext(System.TriggerOperation.AFTER_UNDELETE);
        Test.startTest();
        handler.handle();
        Test.stopTest();
    }
    static testMethod void testHandlerOutOfContext(){
        TestTriggerHandler handler = new TestTriggerHandler();
        Test.startTest();
        try{
            handler.handle();
        }catch(Exception e){
            System.assertEquals(e.getMessage(), 'Trigger handler was called out of context');
        }
        Test.stopTest();
    }
    public class TestTriggerHandler extends FieloTriggerHandler{}
}