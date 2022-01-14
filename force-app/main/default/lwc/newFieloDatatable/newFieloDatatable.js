import { LightningElement, api } from 'lwc';
import Position from '@salesforce/label/c.Position';
import Member from '@salesforce/label/c.Member';
import Points from '@salesforce/label/c.Points';
export default class NewFieloDatatable extends LightningElement {


    @api membersLeaderboard;


    connectedCallback(){
        console.log('MemberLeaderboard', this.membersLeaderboard)
    }

    label = {
        Position,
        Member,
        Points
    };

}