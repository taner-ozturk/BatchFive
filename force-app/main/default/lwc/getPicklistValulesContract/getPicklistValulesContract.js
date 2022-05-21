import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { LightningElement, wire } from 'lwc';

import CONTRACT_OBJECT from '@salesforce/schema/Contract';
import CONTRACT_TYPE_FIELD from '@salesforce/schema/Contract.Contract_Type__c';

export default class GetPicklistValulesContract extends LightningElement {

    renewalRtId;
    typeOptions = [];
    selectedType;

    @wire(getObjectInfo, {objectApiName: CONTRACT_OBJECT})
    objectInfoHandler({data, error}) {
        if(data) {
            console.log(data);
            const rtids = data.recordTypeInfos;
            this.renewalRtId = Object.keys(rtids).find(rtid => rtids[rtid].name === "Renewal");
        }
        if(error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, {fieldApiName: CONTRACT_TYPE_FIELD, recordTypeId: '$renewalRtId'})
    piklistHandler({data, error}) {
        if(data) {
            console.log(data);
            this.typeOptions = this.generatePicklists(data);
        }
        if(error) {
            console.error(error);
        }
    }

    generatePicklists(data) {
        return data.values.map(item => ({
            label : item.label,
            value : item.value
        }));
    }

    changeHandler(event) {
        this.selectedType = event.target.value;
    }
}