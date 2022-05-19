import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import OPP_OBJECT from '@salesforce/schema/Opportunity';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import ACC_FIELD from '@salesforce/schema/Opportunity.AccountId';
import AMOUNT_FIELD from '@salesforce/schema/Opportunity.Amount';
import CLOSEDATE_FIELD from '@salesforce/schema/Opportunity.CloseDate';

export default class RecordEditFormOpp extends LightningElement {
    recordId = '0068c00000o8cbOAAQ';
    showContent = true;
    objectName = OPP_OBJECT;
    fields = {
        name : NAME_FIELD,
        stage : STAGE_FIELD,
        account : ACC_FIELD,
        amount : AMOUNT_FIELD,
        closeDate : CLOSEDATE_FIELD
    };

    successHandler() {
        const successToast = new ShowToastEvent({
            title : "Success",
            message : "Opportunity has been created successfully",
            variant : "success"
        });
        this.dispatchEvent(successToast);
    }
}