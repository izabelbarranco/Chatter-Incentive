public virtual class FieloTriggerHandler {
    @TestVisible
    private System.TriggerOperation TriggerContext;
    
    public FieloTriggerHandler() {
        if( Trigger.isExecuting ) TriggerContext = Trigger.OperationType;
    }
    @TestVisible
    private void setContext(System.TriggerOperation operation){
        TriggerContext = operation;
    }
    public void handle(){
        if(TriggerContext != null){
            switch on TriggerContext {
                when BEFORE_INSERT {
                    this.onBeforeInsert();
                }
                when AFTER_INSERT {
                    this.onAfterInsert();
                }
                when BEFORE_UPDATE {
                    this.onBeforeUpdate();
                }
                when AFTER_UPDATE {
                    this.onAfterUpdate();
                }
                when BEFORE_DELETE {
                    this.onBeforeDelete();
                }
                when AFTER_DELETE {
                    this.onAfterDelete();
                }
                when AFTER_UNDELETE {
                    this.onAfterDelete();
                }
            }
        }else {
            throw new TriggerException('Handle method was called out of context');
        }
    }
    protected virtual void onBeforeInsert(){}
    protected virtual void onAfterInsert(){}
    
    protected virtual void onBeforeUpdate(){}
    protected virtual void onAfterUpdate(){}

    protected virtual void onBeforeDelete(){}
    protected virtual void onAfterDelete(){}
    protected virtual void onAfterUnDelete(){}

    public class TriggerException extends Exception{}
}