import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { LightningElement, wire } from 'lwc';

import OPP_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import TYPE_FIELD from '@salesforce/schema/Opportunity.Type';

export default class Week2Uc3 extends LightningElement {

    oppName;
    petrolRtId;
    stageOptions = [];
    typeOptions = [];
    selectedStage;
    selectedType;

    @wire(getObjectInfo, {objectApiName: OPP_OBJECT})
    objectInfoHandler({data, error}) {
        if(data) {
            console.log('oppurtunity data:', data);
            const rtids = data.recordTypeInfos;
            this.petrolRtId = Object.keys(rtids).find(rtid => rtids[rtid].name === "MentorsRecordType");
        }
        if(error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, {fieldApiName: STAGE_FIELD, recordTypeId: '$petrolRtId'})
    stagePicklistHandler({data, error}) {
        if(data) {
            console.log(data);
            this.stageOptions = this.picklistGenerator(data);
        }
        if(error) {
            console.error(error);
        }
    }

    @wire(getPicklistValues, {fieldApiName: TYPE_FIELD, recordTypeId: '$petrolRtId'})
    typePicklistHandler({data, error}) {
        if(data) {
            console.log(data);
            this.typeOptions = this.picklistGenerator(data);
        }
    }

    picklistGenerator(data) {
        return data.values.map(item => ({
            label : item.label,
            value : item.value
        }));
    }

    nameChangeHandler(event) {
        this.oppName = event.target.value;
    }

    changeHandler(event) {
        const targetName = event.target.name;
        if(targetName === "stage") {
            this.selectedStage = event.target.value;
        } else {
            this.selectedType = event.target.value;
        }
    }
}