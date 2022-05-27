import { LightningElement } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountCtrl.searchAccounts';

export default class SearchAccounts extends LightningElement {
    searchWord;
    accounts;
    error;
    searchHandler(event) {
        this.searchWord = event.target.value;
        searchAccounts({searchKey: this.searchWord})
            .then(result => {
                console.log(result);
                this.accounts = result;
            })
            .catch(error => {
                console.error(error);
                this.error = error;
            })
    }
}