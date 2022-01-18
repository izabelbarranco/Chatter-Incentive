public with sharing class F_GroupWrapper {
    public Boolean isPrimary;
    public CollaborationGroup groupw;
    public F_GroupWrapper(CollaborationGroup curGroup, boolean i) {
        groupw = curGroup;
        isPrimary = i;
    }
}