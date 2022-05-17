import { LightningElement } from 'lwc';

export default class TemplateLooping2 extends LightningElement {
    accounts = [
        {
            id: 1,
            name : "Soft Innovas",
            type : "Education"
        },
        {
            id: 2,
            name : "Universal Containers",
            type : "IT"
        },
        {
            id: 3,
            name : "Facebook",
            type : "Social Networking"
        }
    ];
}