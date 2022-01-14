import { LightningElement, track, api } from 'lwc';
import getLeaderboardList from '@salesforce/apex/F_LeaderboardList.getLeaderboardList'
import getPeriods from '@salesforce/apex/F_LeaderboardList.getPeriods'
import getCurrentMember from '@salesforce/apex/F_LeaderboardList.getCurrentMember'
import getOrder from '@salesforce/apex/F_LeaderboardList.getOrder'
import getCurrentLevel from '@salesforce/apex/F_LeaderboardList.getCurrentLevel'
import profileImage from '@salesforce/resourceUrl/profileImage';


//Labels 
import Quarter from '@salesforce/label/c.Quarter';
import Monthly from '@salesforce/label/c.Monthly';
import Weekly from '@salesforce/label/c.Weekly';
import titleLeaderboard from '@salesforce/label/c.titleLeaderboard';
import { getListUi } from 'lightning/uiListApi';


export default class fieloNewLeaderboard extends LightningElement {

    testImg;
    ProfilePic = profileImage;
    @api hasNotificaiton = false;
    @api parentnumberexibiting;
    @api groupidrecieved;

    @api titleLeaderboard = 'Overall Community';
    @api notificationMessage = "This Leaderboard's new quarter started 10 days ago";
    @api recordId;
    @track value = 'q1';
    @track activeTab;


    @track isLoaded = false;
    @track memberId;
    @track currentMemberLevel;
    @track nextMemberLevel;
    @track hasLeaderboard = false;
    @track noMonthData = false;

    //meta notificaiton variables
    
    @api numberExibiting;
    @api notificationDays;
    @api notificaitonMessageBefore;
    @api notificaitonMessageAfter;
    @api notificaitonMessageQuarter;

    @track weekSelected;
    @track monthSelected;
    @track quarterSelected;

    // mockup data beginning
    @track quarterOptions = [
        {label:'Q1' , value:'q1'},
        {label:'Q2' , value:'q2'},
        {label:'Q3' , value:'q3'},
        {label:'Q4' , value:'q4'},
    ]
    @track yearOptions = [
        {label:'2020' , value:'2020'},
        {label:'2021' , value:'2021'},
    ]
    @track monthOptions = [
        {label:'August' , value:'august'},
        {label:'July' , value:'july'},
        {label:'June' , value:'june'},
    ]
    @track activeMembersLeaderboard = [
        {Position__c:'' , Points__c:'', Member__r:{Name: ''}, avatarImg: this.testImg, isActiveMember:'datatable--active-member' },
    ]

    @track quarterData = {
        todaysDate: new Date(),
        quarterEnd: '',
        quarterBeggining: ''
    }
    // mockup data end

    connectedCallback(){
        let hostname = window.location.href;
        if(hostname.includes('/group') || this.parentnumberexibiting){
            this.hasLeaderboard = true;
            this.hasNotificaiton = this.notificationDays ? true : false;
            this.handlerPeriodOptions();
            this.handleFilterMemberList();
        }
    }

    renderedCallback(){
        if((this.groupidrecieved || this.numberExibiting) && !this.isLoaded){
            this.getLeaderBoardFController();
        }
    }
    
    handlerPeriodOptions(){
        let weeks = [];
        let months = [];
        let quarters = [];

        getPeriods()
        .then(result => {
            if(result){

                console.log(result);
                let d = new Date();
                let clonedResults = JSON.parse(JSON.stringify(result));

                //weeks = this.handleDateFiltering(clonedResults.Week, d);
                // clonedResults.Week = clonedResults.Week.filter((week) => new Date(Date.parse(week.EndDate)) < d || new Date(Date.parse(week.StartDate)) <= d);
                // weeks = clonedResults.Week.map(week => {
                //     //TODO: Label logic
                //     week.StartDate__c = week.StartDate.replaceAll('-', '/'); 
                //     week.EndDate__c = week.EndDate.replaceAll('-', '/'); 
                //     week.label = `${week.StartDate__c} - ${week.EndDate__c}`;
                //     return week; 
                // });
                //this.weekOptions = weeks;
                //this.weekSelected = weeks[0];
                //console.log( 'this.weekSelected', JSON.stringify(this.weekSelected));
                quarters = clonedResults.Quarter.map(quarter => {
                    //TODO: Label logic
                    quarter.StartDate__c = quarter.StartDate.replaceAll('-', '/'); 
                    quarter.EndDate__c = quarter.EndDate.replaceAll('-', '/'); 
                    quarter.label = `${quarter.StartDate__c} - ${quarter.EndDate__c}`;
                    return quarter; 
                });
                this.quarterOptions = quarters;
                this.quarterSelected = quarters[0]; 
                console.log('this.quarterSelected', JSON.stringify(this.quarterSelected));
                months = this.handleDateFiltering(clonedResults.Month, d);

                this.monthOptions = months;
                this.monthSelected = months[0];

                //setup Notifications data

                this.quarterData.quarterBeggining =  new Date(this.quarterOptions[0].StartDate);
                this.quarterData.quarterEnd =  new Date(this.quarterOptions[0].EndDate);
                // if(this.notificationOnOff){
                //     this.template.querySelector('c-fielo-notification-widget').handleNotificationMessage(this.quarterData);
                // }
            }
        })
        .catch(err => {
            console.error(err);
        })
        
    }

    handleDateFiltering(period, currDate){
        period = period.filter((sPeriod) => new Date(Date.parse(sPeriod.EndDate)) < currDate || new Date(Date.parse(sPeriod.StartDate)) <= currDate);
        let filtered = period.map(sPeriod => {
            //TODO: Label logic
            sPeriod.StartDate__c = sPeriod.StartDate.replaceAll('-', '/'); 
            sPeriod.EndDate__c = sPeriod.EndDate.replaceAll('-', '/'); 
            sPeriod.label = `${sPeriod.StartDate__c} - ${sPeriod.EndDate__c}`;
            return sPeriod; 
        });
        return filtered;
    }

    handleFilterMemberList(){
        let memberQuantity = this.numberExibiting ? this.numberExibiting : this.parentnumberexibiting;
        this.totalMembers = parseInt(memberQuantity);        
    }

    @api
    getLeaderBoardFController(groupId = this.groupidrecieved){

        if(!this.groupidrecieved){            
            let hostname = window.location.href;
            hostname = hostname.split('/group');
            hostname = hostname[1].split('/');
            groupId = hostname[1];
            console.log(groupId);
        }
        console.log(this.activeTab);
        console.log(this.totalMembers);
    
        const param = {
            type: this.activeTab,
            groupID: groupId, 
            position: this.totalMembers
        };
        console.log(param);
        var clonedResults = [];
        getLeaderboardList(param)
        .then(result => {
            if(result){
                console.log('result',result);
                clonedResults = JSON.parse(result);
                console.log('clonedResults',clonedResults);
                this.noMonthData = false;
                
                switch (this.activeTab) {
                    case 'Quarter':
                    this.activeMembersLeaderboard = clonedResults.filter(x => x.StartDate__c == this.quarterSelected.StartDate);
                    console.log('Active tab', this.activeTab);
                        break;
                    case 'Month':
                        this.activeMembersLeaderboard = clonedResults.filter(x => x.StartDate__c == this.monthSelected.StartDate);
                        console.log('Active tab', this.activeTab);
                        this.noMonthData = this.activeMembersLeaderboard.length ? false : true;
                        break;    
                    case 'Week':
                        this.activeMembersLeaderboard = clonedResults.filter(x => x.StartDate__c == this.weekSelected.StartDate);
                        break;
                    default:
                        break;
                }
                this.isLoaded = true;
                this.handleMemberIdFilter();
                this.handleUserPhoto();


            }
        })
        .catch(err => {
            console.error(err)
        })
    }

    handleChangeSelect(event){
        const selectType = event.currentTarget.dataset.selecttype;

        console.log(selectType)

        switch (selectType) {
            case 'week':
                this.weekSelected = this.weekOptions.find(week => week.Id == event.currentTarget.value)
                break;

            case 'month': {
                    this.monthSelected = this.monthOptions.find(month => month.Id == event.currentTarget.value)
            }
                break;

                case 'quarter': {
                    this.quarterSelected = this.quarterOptions.find(quarter => quarter.Id == event.currentTarget.value)
                    console.log(this.quarterSelected);
            }
                break;
        
            default:
                break;
        }
        this.getLeaderBoardFController();
    }

    handleTabActive(event){
        const tab = event.target;
        this.activeTab = tab.value;

        if(this.isLoaded){
            this.getLeaderBoardFController();
        }
    }

    handleMemberIdFilter(){
        let groupID = '';

        if(!this.memberId || this.activeMembersLeaderboard.length){
            if(!this.groupidrecieved){
                let hostname = window.location.href.split('/group');
                hostname = hostname[1].split('/');
                groupID = hostname[1];
            }
            else{
                groupID = this.groupidrecieved;
            }

            const param = {
                groupID
            }

            getCurrentMember(param)
            .then(result => {
                if(result){
                    console.log(result)
                    this.memberId = result;

                    this.activeMembersLeaderboard = this.activeMembersLeaderboard.map(member => {
                        if(this.memberId == member.Member__r.Id){
                            member.isActiveMember ='datatable--active-member';
                            console.log('member', member)
                            return member;
                        }
                        else{
                            return member
                        }
                    })

                    //this.getCurrentMemberLevel(this.memberId); 
                }
            })
            .catch(err => {
                console.error(err);
            })


        }

            this.activeMembersLeaderboard = this.activeMembersLeaderboard.map(member => {
                if(this.memberId == member.Member__r.Id){
                    member.isActiveMember ='datatable--active-member';
                    return member;
                }
                else{
                    return member;
                }
            })
    }

    /*
    getCurrentMemberLevel(memberID){

        
        getCurrentLevel({memberID:this.memberId})
        .then(result => { 
            this.currentMemberLevel = result;
            console.log("Current Level",result);
            this.getOrder();
            return result;
           
        })
        .catch(err => {
            console.error(err);
        })

    }

    getOrder(){
        
        getOrder()
        .then(result => { 
            let nextLevelObject;
            console.log("Order",result);

            if(this.currentMemberLevel.FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.FieloPLT__Order__c != 1){
                nextLevelObject =   result.find(level => {
                    return level.FieloPLT__Order__c == this.currentMemberLevel.FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.FieloPLT__Order__c-1});
                    console.log(nextLevelObject)
                    this.nextMemberLevel = nextLevelObject.Name;
            }
            else{
                this.nextMemberLevel = "You're already at the maximum level"
            }
            //console.log("nextmemberlevelvar", nextLevelObject);
            
            this.currentMemberLevel = this.currentMemberLevel.FieloPLT__CurrentLevelMember__r.FieloPLT__Level__r.Name;
            console.log(JSON.stringify(this.currentMemberLevel));
            console.log(JSON.stringify(this.nextMemberLevel));
            
        })
        .catch(err => {
            console.error(err);
        })
    } */
    handleUserPhoto(){
        const hostname = window.location.href.split('.com');
        this.activeMembersLeaderboard = this.activeMembersLeaderboard.map(member => {
            let result = member.Member__r.FieloPLT__User__r.FullPhotoUrl;
            member.avatarImg =  hostname[0] + '.com' + result;
            console.log(member);
            return member;
        })
        
    }



    label = {
        Quarter,
        Monthly,
        Weekly,
        titleLeaderboard
    };

}