import { LightningElement } from 'lwc';

export default class TwoWayDataBinding extends LightningElement {

    studentName;

    getName(){
        this.studentName= "Local Property";
        stdName = "Steve Jobs";
        console.log("this.studentName"+this.studentName);
        console.log();
        return stdName;
    }

    getFullname(firstname, lastname){
        fullname = firstname + " " + lastname;
        return fullname;
    }

    name="Taner";
    title="Salesforce Developer";
    
    handleChange(event){
        this.title = event.target.value;
    }
}