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

    @wire(getObjectInfo, {objectApiName: ACCOUNT_OBJECT})
    objectInfoHandler({data, error}) {
        if(data) {
            console.log(data);
            this.customerRtId = data.defaultRecordTypeId;
            const rtids = data.recordTypeInfos;
            this.vendorRtId = Object.keys(rtids).find(rtid => rtids[rtid].name === 'Vendor');
        }
        if(error) {
            console.log(error);
            this.error = error;
        }
    }

    @wire(getPicklistValues, {fieldApiName: INDUSTRY_FIELD, recordTypeId: '$vendorRtId'})
    picklistHandler({data, error}) {
        if(data) {
            console.log(data);
            this.industryOptions = this.picklistGenerator(data);
        }
        if(error) {
            console.log(error);
            this.error = error;
        }
    }

    picklistGenerator(data) {
        return data.values.map(item => ({
            label : item.label,
            value : item.value
        }));
    }
}