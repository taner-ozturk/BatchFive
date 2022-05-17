import { LightningElement } from 'lwc';

export default class Getters extends LightningElement {
    names = ["Melike", "Dovlet", "Huseyin"];

    num1 = 10;
    num2 = 20;
    
    sum = this.num1 + this.num2;
    
   
    // getter = html de yapamadığım gösterim işlemleri için kullanabiliriz.
    get firstname() {
        return this.names[1];
    }

    //getter = işlem normalde gerekli değil ama sadece çağrıldığında yapılacaksa kullanılır.
    get multiplyNums() { //var, let, const
        var mul = this.num1*this.num2;
        return mul;
    }

    num3 = "20";
    num4 = "10";

    get sumOfNums() {
        return Number(this.num3) + Number(this.num4);
    }


}

//Number(string) = number