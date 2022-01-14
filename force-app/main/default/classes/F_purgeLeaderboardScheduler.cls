global class F_purgeLeaderboardScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        F_PurgeBatch purge = new F_PurgeBatch(3);
        database.executeBatch(purge,200);
    }
}