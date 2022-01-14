global class F_purgeEventScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        F_PurgeBatch purge = new F_PurgeBatch(0);
        database.executeBatch(purge,200);
    }
}