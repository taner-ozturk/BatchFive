import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
    name = "Salesforce Developer!";
    experience = 3;
    fruits = ["Apple", "Pomogranite", "Pineapple", "Orange"];
    experiences = [3 ,10 , 5, 9];
    location = {
        city : "Houston",
        country : "United States",
        postalCode : "51230"
    };

    student ={
        name : "Taner",
        city : "Adana"
    }
}