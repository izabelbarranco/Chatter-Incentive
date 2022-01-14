global class F_ExpireTotalPointsBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        F_ExpireTotalPointsBatch expirePoints = new F_ExpireTotalPointsBatch();
        database.executeBatch(expirePoints,200);
    }
}