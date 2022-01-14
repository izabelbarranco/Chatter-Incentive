public with sharing class FieloFeedCommentHandler extends FieloTriggerHandler{
    private FieloFeedCommentService service;
    public FieloFeedCommentHandler(){
        service = new FieloFeedCommentService();
    }
    public override void onAfterInsert(){
        
        service.fieloEventForumComment((List<FeedComment>) Trigger.new);
    }
}