import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { LightningElement, wire } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class GetPicklistValuesAccount extends LightningElement {
    customerRtId;
    vendorRtId;
    error;
    industryOptions = [];
    selectedIndustry;


    @wire(getPicklistValues, {fieldApiName: INDUSTRY_FIELD, recordTypeId: '0128c000002EyA4AAK'})
    picklistHandler({data, error}) {
        if(data) {
            console.log('getPicklistValues:',data);
            this.industryOptions = this.picklistGenerator(data);
        }
        if(error) {
            console.log(error);
            this.error = error;
        }
    }

    picklistGenerator(data) {
        return data.values.map(a => ({
            label : a.label,
            value : a.value
        }));
    }

    // industryOptions = [
    //     {label : 'Agriculture',
    //     value : 'Agriculture'},
    //     {label : 'Apparel',
    //     value : 'Apparel'},
    //     {label : 'Banking',
    //     value : 'Banking'},
    // ];

}