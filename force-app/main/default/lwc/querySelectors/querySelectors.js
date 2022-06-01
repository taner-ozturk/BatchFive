import { LightningElement } from 'lwc';

export default class QuerySelectors extends LightningElement {
    fruits = ["Apple", "Orange", "Banana", "Pomogranite"];
    clickHandler() {
        //1 element
        const elem = this.template.querySelector('h1');
        console.log(elem.innerText);
        elem.style.border = '4px solid blue';
        elem.style.backgroundColor = 'red';

        //multiple elements
        const fruitElems = this.template.querySelectorAll('.fruit');
        fruitElems.forEach(item => {
            console.log(item.innerText);
            item.style.backgroundColor = 'green';
            item.setAttribute('class', 'slds-align_absolute-center');
            
        });
    }
}