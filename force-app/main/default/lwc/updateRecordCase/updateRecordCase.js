import { updateRecord } from 'lightning/uiRecordApi';
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UpdateRecordCase extends LightningElement {
    formdata = {};
    recordId = '5008c00001FljmPAAR';
    changeHandler(event) {
        this.formdata['Id'] = this.recordId;
        const {name, value} = event.target;
        this.formdata[name] = value;
    }

    updateCase() {
        const recordInput = {fields: this.formdata};

        updateRecord(recordInput)
            .then(result => {
                console.log(result);
                this.creatToast("Success", "Case has been updated sucessfully!", "success");
            })
            .catch(error => {
                console.error(error);
                this.creatToast("Error", "Error occurred while updating the case", "error");
            })
    }

    creatToast(title, message, variant) {
        const toast = new ShowToastEvent({title, message, variant});
        this.dispatchEvent(toast);
    }
}