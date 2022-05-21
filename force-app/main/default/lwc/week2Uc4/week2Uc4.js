import { getRecord } from 'lightning/uiRecordApi';
import { LightningElement, wire } from 'lwc';

import ACCOUNT_FIELD from '@salesforce/schema/Case.AccountId';
import SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import PRIORITY_FIELD from '@salesforce/schema/Case.Priority';
import REASON_FIELD from '@salesforce/schema/Case.Reason';
import TYPE_FIELD from '@salesforce/schema/Case.Type';
import STATUS_FIELD from '@salesforce/schema/Case.Status';

const FIELDS = [ACCOUNT_FIELD, SUBJECT_FIELD, PRIORITY_FIELD, REASON_FIELD, TYPE_FIELD, STATUS_FIELD];

export default class Week2Uc4 extends LightningElement {

    recordId = '5008c00001Isl4wAAB';
    account;
    subject;
    reason;
    priority;
    type;
    status;

    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    recordHandler({data, error}) {
        if(data) {
            console.log('getRecord : ', data);
            this.account = data.fields.AccountId.value;
            this.subject = data.fields.Subject.value;
            this.priority = data.fields.Priority.value;
            this.reason = data.fields.Reason.value;
            this.type = data.fields.Type.value;
            this.status = data.fields.Status.value;
        }
    }
}