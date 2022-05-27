import { createRecord } from 'lightning/uiRecordApi';
import { LightningElement } from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateRecordContact extends LightningElement {
    formData = {};
    // name;
    // value;
  
    changeHandler(event) {
        
        // this.name = event.target.name;
        // this.value = event.target.value;

        const {name, value} = event.target;
        //Her input için name değerini alır.
        this.formdata[name] = value;

        // this.formdata[event.target.name] = event.target.value;

        // formdata{
        //     FirstName='Mahmut',
        //     LastName ='Çepeçevre',
        //     Title = 'merhaba',
        //     Email ='mahmut@gmail.com',
        //     Department='Frondend'
        // }; 

    }

    createContact() {
        const recordInput = {
            apiName : CONTACT_OBJECT.objectApiName,
            fields : this.formData
        };
        
        createRecord(recordInput)
            .then(result => {
                console.log(result);
                this.template.querySelector('form.contactform').reset();
                this.formdata = {};
                this.creatToast("Sucess", "Record has been updated successfully", "success");
            })
            .catch(error => {
                console.error(error);
                this.creatToast("Error", "Error occurred while creating the record", "error");
            })
    }

    creatToast(title, message, variant) {
        const toast = new ShowToastEvent({title, message, variant});
        this.dispatchEvent(toast);
    }
}