import { LightningElement } from 'lwc';

export default class MyInfo extends LightningElement {

    username="Taner";
    role="Salesforce Architect";

    changeHandler(event) {
        this.username = event.target.value;
    }

    handleRoleChange(event) {
        this.role = event.target.value;
    }
    
    get roles() {
        return [
            { label: 'Salesforce Admin', value: 'Salesforce Admin' },
            { label: 'Salesforce Developer', value: 'Salesforce Developer' },
            { label: 'Salesforce Architect', value: 'Salesforce Architect' }
        ];
    }
}