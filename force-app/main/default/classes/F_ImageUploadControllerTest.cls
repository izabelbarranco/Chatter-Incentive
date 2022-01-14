@isTest
public class F_ImageUploadControllerTest {
	@isTest
    public static void unitTest1(){
        
        FieloPLT__Program__c program = new FieloPLT__Program__c(Name = 'Program A');
        Insert program; 
        
        FieloPLT__Level__c level = new FieloPLT__Level__c(
            Name = 'Level Test',
            FieloPLT__Program__c = program.Id,
            FieloPLT__Image__c = 'some img id to change',
            FieloPLT__ExternalId__c = 'Level Test 01'
        );        
        insert level;

		//Insert contentdocument data
        ContentVersion cv = new ContentVersion();
        cv.title = 'Content Version Test';      
        cv.PathOnClient ='test';           
        cv.VersionData = Blob.valueOf('Testing base 64 encode');          
        insert cv;         
        
        ContentVersion upldImage = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
                
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = level.id;
        contentlink.contentdocumentid = upldImage.contentdocumentid;
        insert contentlink;
        
        String imgUrl;
        Test.startTest();
        	F_ImageUploadController.setImageToEvent(upldImage.ContentDocumentId, level.Id);
        	imgUrl = F_ImageUploadController.getImageFromEvent(level.Id);
        Test.stopTest();    
        
        List<FieloPLT__Level__c> levels = [SELECT FieloPLT__Image__c, FieloPLT__ExternalURL__c FROM FieloPLT__Level__c WHERE Id = :level.Id];
        
        system.assert(!levels.isEmpty(), 'Error: Level not found.');
        system.assert(levels[0].FieloPLT__Image__c == upldImage.ContentDocumentId, 'Error: Image id added on level are incorrect.');
        system.assert(levels[0].FieloPLT__ExternalURL__c != null, 'Error: Image url not found in level.');                
        system.assert(levels[0].FieloPLT__ExternalURL__c == imgUrl, 'Error: Image url in level is incorrect.');                
	}
}