import { LightningElement } from 'lwc';

export default class ProgressbarParentComp extends LightningElement {
    progressValue= 50;
    handleProgress(event){
        this.progressValue = event.detail;
    }
}