public class F_ImageUploadController {
    
    @AuraEnabled
    public static void setImageToEvent(Id upldImageId, Id eventId){
        if(upldImageId != null && eventId != null){
            FieloPLT__Level__c event = [SELECT Id, Name, FieloPLT__Image__c FROM FieloPLT__Level__c WHERE Id =: eventId LIMIT 1][0];
            if(event != null){
                //If the event already has an image, the system deletes it
                if(event.FieloPLT__Image__c != null){
                    delete([SELECT id FROM ContentDocument where id =: event.FieloPLT__Image__c]);
                }

                //Uploaded image id is setted in the etex event and the public URL is created
                ContentVersion cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId =: upldImageId LIMIT 1][0];
                
                ContentDistribution cd = new ContentDistribution();
                cd.Name = 'Fielo-Public-URL-' + upldImageId;
                cd.ContentVersionId = cv.Id;
                cd.PreferencesAllowViewInBrowser = true;
                cd.PreferencesLinkLatestVersion = true;
                cd.PreferencesNotifyOnVisit = false;
                cd.PreferencesPasswordRequired = false;
                cd.PreferencesAllowOriginalDownload = true;
                insert cd;
                
                cd = [SELECT ContentDownloadUrl, DistributionPublicUrl FROM ContentDistribution WHERE Id =: cd.Id LIMIT 1];
                String externalURL = cd.ContentDownloadUrl;
                externalURL = externalURL.replace('download', 'renditionDownload');
                externalURL = externalURL.replace('ids', 'versionId');
                externalURL = externalURL.replace('&asPdf=false', '');
                externalURL = externalURL.replace('%2F', '/');
                externalURL += '&rendition=ORIGINAL_Jpg';
                
                event.FieloPLT__Image__c = upldImageId;
                event.FieloPLT__ExternalURL__c = externalURL;
                update event;
            }           
        }
    }
    
    @AuraEnabled
    public static String getImageFromEvent(Id eventId){
        List<FieloPLT__Level__c> levels = [SELECT FieloPLT__ExternalURL__c FROM FieloPLT__Level__c WHERE Id = :eventId];
        if(levels.isEmpty()) return null;
        return levels[0].FieloPLT__ExternalURL__c;
    }
}