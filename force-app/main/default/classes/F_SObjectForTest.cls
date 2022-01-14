@isTest
public without sharing class F_SObjectForTest {
    
    public static Integer LOTE = 150;
    
    public static User getUserWithRole(Id aProfileId) {
        UserRole ur = [SELECT Id,DeveloperName FROM UserRole LIMIT 1];
        
        return new User(
            Username = 'usertest2@fielo.com',
            Email = 'test2@fielo.com',
            LastName = 'Sobrenome2',
            Alias = 'VN2',
            CommunityNickname = 'vnscteste2',
            EmailEncodingKey = 'ISO-8859-1',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = aProfileId,
            UserRoleId = ur.Id
        );
        
    }
    
    public static User getUser( ID aProfileId ) {
        return getUser( aProfileId, null );
    }
    
    public static User getUser( ID aProfileId, String aSuffix ) {
        boolean lHasSuffix = String.isBlank( aSuffix );
        return new User(
            Username = 'usertest1@fielo.com' + ( lHasSuffix ? '':aSuffix ),
            Email = 'test@fielo.com',
            LastName = 'Lastname',
            Alias = 'VN' + ( lHasSuffix ? '':aSuffix.left( 2 ) ),
            CommunityNickname = 'vnscteste' + ( lHasSuffix ? '':aSuffix ),
            EmailEncodingKey = 'ISO-8859-1',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = aProfileId
        );
    }
    //method to create a portal user
     public static User getUser( ID aProfileId, String aSuffix , ID ContactId) {
        boolean lHasSuffix = String.isBlank( aSuffix );
        return new User(
            Username = 'nome@fielo.com',
            Email = 'nome@fielo.com',
            LastName = 'Sobrenome',
            Alias = 'VN' + ( lHasSuffix ? '':aSuffix.left( 2 ) ),
            CommunityNickname = 'vnscteste' + ( lHasSuffix ? '':aSuffix ),
            EmailEncodingKey = 'ISO-8859-1',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'pt_BR',
            LanguageLocaleKey = 'pt_BR',
            ProfileId = aProfileId,
            ContactId = ContactId
        );
    }
    
    public static Profile getProfile( String aProfileName ) {
        return [ Select Id From Profile Where Name=:aProfileName Limit 1 ];
    }
    
    
    public static Account getAccount() {
        return new Account(
            Name = 'Account for Test',
            NumberOfEmployees = 1
        );
    }
    
    public static Account getAccount(String aName) {
        return new Account(
            Name = String.isNotBlank(aName) ? aName : 'Account for Test',
            NumberOfEmployees = 1
        );
    }
    
    public static Contact getContact(Id recordTypeId){
        return new Contact(
            FirstName = 'Name',
            LastName = 'Contact',
            RecordTypeId = recordTypeId
        );
    }
    
    public static Contact getContact(){
        return new Contact(
            FirstName = 'Name',
            LastName = 'Contact'
        );
    }
    
    //FIELO OBJECTS
    public static FieloPLT__Member__c getMember(String aName, Id aPrg){
        
        return new FieloPLT__Member__c(
            Name = aName,
            FieloPLT__Program__c = aPrg,
            FieloPLT__Points__c = 0,
            FieloPLT__Type__c = 'Individual Account',
            FieloPLT__Email__c = 'testemail@email.com.br'
            
        );
    }
    
    public static FieloPLT__Member__c getMember(String aName, Id aPrg, Id userId){
        
        return new FieloPLT__Member__c(
            Name = aName,
            FieloPLT__Program__c = aPrg,
            FieloPLT__Points__c = 0,
            FieloPLT__Type__c = 'Individual Account',
            FieloPLT__User__c = userId,
            FieloPLT__Email__c = 'testemail@email.com.br'
            
        );
    }
    
   public static FieloPLT__Member__c getMember(String aName, Id aPrg, Id userId, Id contId){
        
        return new FieloPLT__Member__c(
            Name = aName,
            FieloPLT__Program__c = aPrg,
            FieloPLT__Points__c = 0,
            FieloPLT__Type__c = 'Individual Account',
            FieloPLT__User__c = userId,
            FieloPLT__Email__c = 'testemail@email.com.br',
            FieloPLT__Contact__c = contId
            
        );
    }
    
    
    public static FieloPLT__Program__c getProgram(String aName) {
        return new FieloPLT__Program__c(
            Name = aName,
            FieloPLT__OnlineTransactionProcessing__c = true
        );
    }
    
    
    public static FieloPLT__Level__c getLevel(String aName, Id programId, Integer order){
        
        return new FieloPLT__Level__c(
            Name = aName,
            FieloPLT__IsActive__c = true,
            FieloPLT__Program__c = programId,
            FieloPLT__Order__c = order
        );
    }
    
    public static FieloPLT__LevelMember__c getLevelMember(Id levelId, Id memberId){
        
        return new FieloPLT__LevelMember__c(
            FieloPLT__Level__c = levelId,
            FieloPLT__Member__c = memberId
        );
    }
    
    public static FieloPLT__Badge__c getBadge(Id programId){
        return new FieloPLT__Badge__c(
            Name = 'Test Badge',
            FieloPLT__Program__c = programId,
            FieloPLT__Status__c = 'Active'
        );
    }
    
    public static FieloPLT__BadgeMember__c getBadgeMember(Id badgeId, Id memberId){
        
        return new FieloPLT__BadgeMember__c(
            FieloPLT__Badge__c =  badgeId,
            FieloPLT__Member__c =  memberId
        );
    }
    
    
    public static FieloPLT__Redemption__c getRedemption( Id aMemberId ){
        return new FieloPLT__Redemption__c(
            FieloPLT__Member__c = aMemberId        
        );
    }
    
    
    public static FieloPLT__Event__c  getEvent(){
        return new FieloPLT__Event__c ();
    }
    
    public static FieloPLT__Reward__c getReward(Id aProgramId) {
        return new FieloPLT__Reward__c(
            FieloPLT__Program__c = aProgramId,
            FieloPLT__Points__c = 0,
            Name = 'Serviço teste ' + Datetime.now().getTime(),
            FieloPLT__Stock__c = 10000,
            FieloPLT__UniqueVoucher__c = true,
            FieloPLT__Image__c = 'imagemTeste',
            FieloPLT__ExpirationDate__c = system.today().addDays(100)
            //FieloPLT__Provider__c = aAccId
        );
    }
    
    public static FieloPLT__RedemptionItem__c getRedemptionItem( Id aredemptionId, Id arewardId ) {
        return new FieloPLT__RedemptionItem__c(
            FieloPLT__Redemption__c = aredemptionId,
            FieloPLT__Reward__c = arewardId,
            FieloPLT__Quantity__c = 1
        );
    }
    
    public static FieloPLT__Promotion__c getPromotion(Id aIdPrg){
        return new FieloPLT__Promotion__c(
            Name = 'Teste',
            FieloPLT__Program__c = aIdPrg
        );
    }
    
    public static FieloPLT__RuleTrigger__c getRuleTrigger(){
        return new FieloPLT__RuleTrigger__c(
            Name = 'Teste',
            FieloPLT__Object__c = 'FieloPLT__Event__c',
            FieloPLT__LookupFromTransaction__c = 'FieloPLT__Event__c',
            FieloPLT__LookupfromTracker__c = 'FieloPLT__Event__c'
            
        );
    }
    
    public static FieloPLT__Action__c getAction(String aRuleTrigger){
        return new FieloPLT__Action__c(
            FieloPLT__RuleTrigger__c = aRuleTrigger,
            name = 'teste2',
            FieloPLT__TargetMember__c = 'FieloPLT__Member__c'
        );
    }
    
    public static FieloPLT__Rule__c getRule(String aName, Id aPromo, Id aIdAction){
        return new FieloPLT__Rule__c(
            Name = aName,
            FieloPLT__Promotion__c = aPromo,
            FieloPLT__ConversionValue__c = 10,
            FieloPLT__PointConversionMode__c = 'Fixed Value',
            FieloPLT__RecordFieldName__c = 'Name',
            FieloPLT__Action__c = aIdAction
            
        );
    }
    
    public static Id  getPointType(){
        
        FieloPLT__PointType__c lPointType = [SELECT Id FROM FieloPLT__PointType__c LIMIT 1];
        
        return lPointType != null ? lPointType.id: null;
    }
    
    public static FieloPLT__Point__c getPoint(Id aMemberId, Id aRuleId){
        return new FieloPLT__Point__c(
            FieloPLT__Member__c = aMemberId,
            FieloPLT__TotalPoints__c = 10,
            FieloPLT__Rule__c = aRuleId,
            FieloPLT__PointType__c = getPointType()
            
        );
        
    }
    
    public static FieloPLT__Point__c getPoint(Id aMemberId, Id aRuleId, String transactionId){
        
        return new FieloPLT__Point__c(
            FieloPLT__Member__c = aMemberId,
            FieloPLT__TotalPoints__c = 10,
            FieloPLT__PointType__c = getPointType(),
            FieloPLT__Rule__c = aRuleId,
            FieloPLT__Transaction__c = transactionId
        );
        
    }
    
    public static FieloPLT__Transaction__c getTransaction(Id aMemberId){
        return new FieloPLT__Transaction__c(        
            FieloPLT__Member__c = aMemberId,
            FieloPLT__Points__c = 10,
            FieloPLT__Value__c = 500
        );
    }
    
    public static FieloPLT__Agreement__c getAgreement( String aProgramId ){
        return new FieloPLT__Agreement__c(
            FieloPLT__Program__c = aProgramId,
            FieloPLT__Agreement__c = 'Qualquer texto **Destaque** outro texto'
        );
    }
    
    public static void setPublicSettings() {
        FieloPLT__PublicSettings__c lPublicSettings = new FieloPLT__PublicSettings__c(
            FieloPLT__ContactRelationshipClass__c = '');
        insert lPublicSettings;
    }
    
    
    public static User loadUserLoggedMember (){    
        
        FieloPLT__Program__c lProg = F_SObjectForTest.getProgram('Consultores');
        insert lProg; 
        
        Profile lPerfil = getProfile('Fielo REST');
        
        Account lAcc = getAccount();
        insert lAcc;
        
        Contact lCtt = getContact();
        lCtt.AccountId = lAcc.Id;
        insert lCtt;
        
        User lUs = getUser(lPerfil.Id);
        lUs.ContactId = lCtt.Id;
        insert lUs;
        
        FieloPLT__Member__c lMb = getMember('Test', lProg.Id); 
        lMb.FieloPLT__User__c = lUs.Id;
        insert lMb; 
        
        return lUs;
    }
    
    public static FieloPLT__Segment__c getSegment(String aName, String aProgramId) {
        return new FieloPLT__Segment__c ( 
            Name = aName,
            FieloPLT__Description__c = 'Desc Test',
            FieloPLT__Program__c = aProgramId
        );
    }
    
    //FIELO CHALLENGE
    
    public static FieloPLT__Challenge__c getChallenge(Id programId){
        return new FieloPLT__Challenge__c( 
            Name = 'Test Challenge',
            FieloPLT__Program__c = programId,
            FieloPLT__StartDate__c = Date.newInstance(2020,01,01),
            FieloPLT__EndDate__c = Date.newInstance(2020,12,01)
        );
    }
    
    public static FieloPLT__ChallengeMember__c getChallengeMember(Id challengeId, Id memberId){
        return new FieloPLT__ChallengeMember__c( 
            FieloPLT__Challenge__c = challengeId,
            FieloPLT__Member__c = memberId            
        );
    }
    
    public static FieloPLT__ChallengeReward__c getChallengeRewards(Id challengeId){
        return new FieloPLT__ChallengeReward__c(
            FieloPLT__Challenge__c =challengeId,
            FieloPLT__PointConversionMode__c = 'Fixed Value',
            FieloPLT__ConversionValue__c = 10
        );
    }
    
    public static FieloPLT__Mission__c getMission(Id actionId, Id challengeId){
        return new FieloPLT__Mission__c(
            Name = 'Test Mission',
            FieloPLT__Action__c = actionId,
            FieloPLT__Challenge__c = challengeId,
            FieloPLT__ObjectiveType__c = 'Counter',
            FieloPLT__LeaderboardMode__c = 'Performance',
            FieloPLT__ObjectiveValue__c = 1,
            FieloPLT__Operator__c = 'equal'
        );
    }
    
    public static FieloPLT__MissionMember__c getMissionMember(Id missionId, Id challengeMemberId){
        return new FieloPLT__MissionMember__c(
            FieloPLT__ChallengeMember__c = challengeMemberId,
            FieloPLT__Mission__c = missionId
        );
    }
    
   
    
    //SPECIFIC CUSTOM OBJECTS
   
}