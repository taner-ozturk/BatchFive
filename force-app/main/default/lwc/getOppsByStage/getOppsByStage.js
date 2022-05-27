import { LightningElement, wire } from 'lwc';
import getOppsByStage from '@salesforce/apex/OpportunityCtrl.getOppsByStage';

const COLUMNS = [
    {label: "Opportunity Name", fieldName: "Name", type: "text"},
    {label: "Opportunity Type", fieldName: "Type", type: "text"},
    {label: "Amount", fieldName: "Amount", type: "currency"},
    {label: "Stage", fieldName: "StageName", type: "text"}
];

export default class GetOppsByStage extends LightningElement {
    stgName = 'Closed Won';
    columns = COLUMNS;

    @wire(getOppsByStage, {stage: '$stgName'})
    opportunities;
}