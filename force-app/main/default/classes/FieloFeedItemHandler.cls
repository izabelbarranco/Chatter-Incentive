public with sharing class FieloFeedItemHandler extends FieloTriggerHandler{
    private FieloFeedItemService service;
    public FieloFeedItemHandler(){
        super();
        service = new FieloFeedItemService();
    }
    public override void onAfterInsert(){
        System.debug('entrei on afterinsert');
        service.fieloEventForumPost((List<FeedItem>) Trigger.new);
        service.fieloSharePost((List<FeedItem>) Trigger.new);
    }
    public override void onAfterUpdate(){ 
         
    }
}