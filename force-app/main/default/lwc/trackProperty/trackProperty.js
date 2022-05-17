import { LightningElement, track } from 'lwc';

export default class TrackProperty extends LightningElement {
    //non-primitive data type larda
    //liste(array) veya object' ler için kullanılır.
    //bir defa kullandıktan sonra silsenizde varmış gibi davranır.
    //komponent içi variable değişikliğini takip etmeye yarar.
    
    @track contact = {
        name : "Steve Jobs",
        stay : "United States",
        company : "Apple"
    }
    //Event = olay dinleyicisi
    //target = olay dinleyicisini tetikleyen olayı getirir.
    handleChange(event) {
        this.contact.stay = event.target.value;
    }
}