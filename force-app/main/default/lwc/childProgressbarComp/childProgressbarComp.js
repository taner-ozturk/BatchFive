import { LightningElement } from 'lwc';

export default class ChildProgressbarComp extends LightningElement {
    childProgressValue;
    handleChange(event){
        this.childProgressValue = event.target.value;

        //create Custom Event

        const selectedEvent = new CustomEvent('progressbarchange', {detail: this.childProgressValue});
        this.dispatchEvent(selectedEvent);
    }
}