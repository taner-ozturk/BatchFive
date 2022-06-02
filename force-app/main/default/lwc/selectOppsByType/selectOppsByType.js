import { LightningElement } from 'lwc';
import getOppsByType from '@salesforce/apex/OpportunityCtrl.getOppsByType';

const COLUMNS = [
    {label: "Opportunity Name", fieldName: "Name", type: "text"},
    {label: "Opportunity Type", fieldName: "Type", type: "text"},
    {label: "Amount", fieldName: "Amount", type: "currency"},
    {label: "Stage", fieldName: "StageName", type: "text"}
];

export default class SelectOppsByType extends LightningElement {
    selectedType;
    opps;
    columns = COLUMNS;

    changeHandler(event) {
        this.selectedType = event.target.value;
        getOppsByType({type: this.selectedType})
            .then(result => {
                this.opps = result;
            }) 
            .catch(error => {
                console.error(error);
            })
    }

    get typeOptions() {
        return [
            {label: "Existing Customer - Upgrade", value: "Existing Customer - Upgrade"},
            {label: "Existing Customer - Replacement", value: "Existing Customer - Replacement"},
            {label: "Existing Customer - Downgrade", value: "Existing Customer - Downgrade"},
            {label: "New Customer", value: "New Customer"}
        ];
    }
}