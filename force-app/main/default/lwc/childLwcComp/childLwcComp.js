import { LightningElement } from 'lwc';
export default class ChildLwcComp extends LightningElement {
    handleClick(){
        const selectedEvent = new CustomEvent("clickme");
        this.dispatchEvent(selectedEvent);
    }
}