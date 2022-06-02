import { api, LightningElement } from 'lwc';
export default class DisplayResults extends LightningElement {
    @api results;
    @api columns;
}



// export default class DisplayResults extends LightningElement {
//     @api results;
//     @api columns;

//     sortHandler(event) {
//         const sortedBy = event.detail.fieldName;
//         const sortedDirection = event.detail.sortDirection;
//         this.sortData(sortedBy,sortedDirection);
//     }
//     sortData(fieldName,sortDirection) {
//         var data = JSON.parse(JSON.stringify(this.results));
//         //function to return the value stored in the field
//         var key =(a) => a[fieldName]; 
//         var reverse = sortDirection === 'asc' ? 1: -1;
//         data.sort((a,b) => {
//             let valueA = key(a) ? key(a).toLowerCase() : '';
//             let valueB = key(b) ? key(b).toLowerCase() : '';
//             return reverse * ((valueA > valueB) - (valueB > valueA));
//         });

//         //set sorted data to results attribute
//         this.results = data;
//     }
// }