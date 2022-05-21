import { getFieldDisplayValue, getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, wire } from 'lwc';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import ACC_NUM_FIELD from '@salesforce/schema/Account.AccountNumber';
import RATING_FIELD from '@salesforce/schema/Account.Rating';

const FIELDS = [NAME_FIELD, TYPE_FIELD, INDUSTRY_FIELD, REVENUE_FIELD, ACC_NUM_FIELD, RATING_FIELD];

export default class GetRecordAccount extends LightningElement {
    /** WAY 1 **/
    // recordId = '0015j00000Ymy8EAAR';
    // name;
    // type;
    // industry;
    // revenue;
    // accnum;
    // rating;

    // @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    // accountHandler({data, error}) {
    //     if(data) {
    //        console.log(data); //data.fields.fieldApiName.value
    //        this.name = data.fields.Name.value;
    //        this.type = data.fields.Type.value;
    //        this.industry = data.fields.Industry.value;
    //        this.revenue = data.fields.AnnualRevenue.displayValue;
    //        this.accnum = data.fields.AccountNumber.value;
    //        this.rating = data.fields.Rating.value;
    //     }
    //     if(error) {
    //         console.error(error);
    //     }
    // }
    /** WAY 1 END **/

    /** WAY 2 **/
    recordId = '0018c00002HrodfAAB';
    name;
    type;
    industry;
    revenue;
    accnum;
    rating;

    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    accountHandler({data, error}) {
        if(data) {
           console.log(data); //data.fields.fieldApiName.value
           this.name = getFieldValue(data, NAME_FIELD);
           this.type = getFieldValue(data, TYPE_FIELD);
           this.industry = getFieldValue(data, INDUSTRY_FIELD);
           this.revenue = getFieldDisplayValue(data, REVENUE_FIELD);
           this.accnum = getFieldValue(data, ACC_NUM_FIELD);
           this.rating = getFieldValue(data, RATING_FIELD);
        }
        if(error) {
            console.error(error);
        }
    }
    /** WAY 2 END */
}