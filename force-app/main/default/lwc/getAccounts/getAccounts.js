import { LightningElement, wire } from 'lwc';
import gelenAccounts from '@salesforce/apex/AccountCtrl.getAccounts';


const COLUMNS = [
    {label: "Account Name", fieldName: "Name", type: "text"},
    {label: "Account Type", fieldName: "Type", type: "text"},
    {label: "Industry", fieldName: "Industry", type: "text"},
    {label: "AnnualRevenue", fieldName: "AnnualRevenue", type: "currency"}
];

export default class GetAccounts extends LightningElement {
    columns = COLUMNS;

    @wire(gelenAccounts)
    gelmisAccounts;
}