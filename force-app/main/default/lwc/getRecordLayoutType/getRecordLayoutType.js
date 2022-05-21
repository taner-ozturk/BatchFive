import { LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';



export default class GetRecordLayoutType extends LightningElement {



    @wire(getRecord, { recordId: '0018c00002HrodfAAB', layoutTypes: ['Full'], modes: ['View'] })
    accountRecord;

}