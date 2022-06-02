import { LightningElement } from 'lwc';

export default class P2cParentNonprimitives2 extends LightningElement {
    location = {
        city: "Chicago",
        country: "United States",
        postalCode: "53301"
    }
    info = {
        name: "Taner",
        city: "Adana",
        title: "Salesforce Admin"
    }
}