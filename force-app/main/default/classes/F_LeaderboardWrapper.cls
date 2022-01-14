global class F_LeaderboardWrapper implements Comparable {
	
    public F_Leaderboard__c lBoard;
    
    // Constructor
    public F_LeaderboardWrapper(F_Leaderboard__c l) {
        lBoard = l;
    }
    
    // Compare opportunities based on the opportunity amount.
    global Integer compareTo(Object compareTo) {
        // Cast argument to OpportunityWrapper
        F_LeaderboardWrapper compareToBoard = (F_LeaderboardWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (lBoard.Points__c > compareToBoard.lBoard.Points__c) {
            // Set return value to a positive value.
            returnValue = -1;
        } else if (lBoard.Points__c < compareToBoard.lBoard.Points__c) {
            // Set return value to a negative value.
            returnValue = 1;
        } else if ((lBoard.Points__c == null) && (compareToBoard.lBoard.Points__c != null)){
            // nulls-first implementation
            returnValue = -1;
        } else if ((lBoard.Points__c != null) && (compareToBoard.lBoard.Points__c == null)){
            // nulls-first implementation
            returnValue = 1;
        }        
        return returnValue;
    }
}