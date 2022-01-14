global class F_purgePointScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        F_PurgeBatch purge = new F_PurgeBatch(1);
        database.executeBatch(purge,200);
    }
}