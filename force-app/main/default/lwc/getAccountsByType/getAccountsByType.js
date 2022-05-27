import { LightningElement, wire } from 'lwc';
import getAccountsByType from '@salesforce/apex/AccountCtrl.getAccountsByType';

const COLUMNS = [
    {label: "Account Name", fieldName: "Name", type: "text"},
    {label: "Account Type", fieldName: "Type", type: "text"},
    {label: "Industry", fieldName: "Industry", type: "text"},
    {label: "AnnualRevenue", fieldName: "AnnualRevenue", type: "currency"}
];

export default class GetAccountsByType extends LightningElement {
    accType = 'Customer - Direct';
    columns = COLUMNS;

    @wire(getAccountsByType, {type: '$accType'})
    accounts;
}