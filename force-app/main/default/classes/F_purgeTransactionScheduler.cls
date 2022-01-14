global class F_purgeTransactionScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        F_PurgeBatch purge = new F_PurgeBatch(2);
        database.executeBatch(purge,200);
    }
}