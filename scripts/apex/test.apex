List<COntact> contacts = SELECT Id From Contact WHERE AccountId = recordId AND LastName = lastname AND Email = email


if(contacts = null) {

    lets create contact record
} else {
    prompt the user there is already a contact exist
}


AccountId = 0015j00000XxU7qAAF;

List<Account> accountList = [SELECT Id, ShippingCountry, ShippingStreet, ShippingCity, ShippingPostalCode, ShippingState];

Contact contactToCreate = new Conact(
    LastName = 'Yaswanth',
    BillingStreet = accountList[0].ShippingStreet,
    BillingCity = accountList[0].ShippingCity
)

insert contactToCreate;



Contact contactToCreate = new Conact();

contactToCreate.ShippingCity = 

contactToCreate.BillingStreet = accountList[0].ShippingStreet;


before update/.before insert 
accountTrigger () {

    
    for(COntact contactInstance : Trigger.New ) {

        contactInstance.Department = 'Education';
    }
}


1. Save => CLicking save from the UI

    2. before tigger 



            3. DataBase


Location A -> Starting

Location ABC - Alex, 

Location B - John -> finish


1. way


accountTrigger on Account(before insert, after insert) {

    for(Account accountInstance : Trigger.New) {

        if(accountInstance.ShippingStreet == null ) {
            accountInstance.ShippingStreet = accountInstance.BillingStreet;
        } else {
            
        }
        if(accountInstance.ShippingState == null ) {
            accountInstance.ShippingStreet = accountInstance.BillingStreet;
        }
        if(accountInstance.ShippingCity == null ) {
            accountInstance.ShippingStreet = accountInstance.BillingStreet;
        }
        if(accountInstance.ShippingPostalCode == null ) {
            accountInstance.ShippingStreet = accountInstance.BillingStreet;
        }
    }
}


accountTrigger on Account(before update, after update) {

    for(Account accountInstance : Trigger.New) { //3

        accountInstance.ShippingStreet = accountInstance.BillingStreet;
        
        list<Contact> contactList = [SELECT Id FROM Contact WHEERE AccountId = :accountInstance.Id]; 20K Records
        here is the compiler
        
        Messaging.SendEmail(mailInstance);

    }
}

insert accountList; // 3accounts

//Transaction
Start from save operation

    account 1
    how many soql rows = 20K
    how many soql statements = 1

    account 2 for for loop
    how many soql rows = 20K
    how many soql statements =  1

    per Transaction: account 1 + Account 2

    total  soql rows = 40K
    total soql statements =  2

    account 3 for for loop
    how many soql rows = 20K
    how many soql statements =  1

    per Transaction: account 1 + Account 2 + account 3

    total  soql rows = 60K //50K
    total soql statements =  3 //100
finishes the tour after commiting to the database 


10M+

3 acounts => 20K Records 

Account having more than 60K Contacts 


    send an email => 


    Messaging.SendEmail(mailInstance);


    100emails => contacts 
}


insert accountInstance; //1st dml from the user


//Trigger or Flow

//Trigger
if you insert insert accountInstance; //1st dml from the code

before triggers 
save to the database
after trigger 


stack depth


//15-04-2022

List<Id> accountIdList = new List<Id>();

for(Account accountInstance : Account List) {
    accountIdList.add(accountInstance.Id);
}

List<Contact> contactList = [SELECT Id FROM Contact WHERE AccountId IN :accountIdList ];

recordId => flow


//Single Account
Account accountInstance = new Account(
    Name = 'ABC Techonoogies'
);




for(Account accountInstance : Account List) {

    if(accountInstance.Address != Old Address) {
        List<Contact> contactList = [SELECT Id, Name, Address, Phone, Fax, Email FROM Contact WHERE AccountId = :accountInstance.Id ];
    }

    accountIdList.add(accountInstance.Id);
}

if() {
    List<Contact> contactsToUpdate = new List<Conact>();

    for(Contact contactInstance :  contactList) {
       

        //typical writing
        contactInstance.MailingStreet = accountInstance.BillingStreet;
        contactsToUpdate.add(contactToUpdate);

        Contact contactToCreate = new Conact(
            LastName = 'Yaswanth',
            BillingStreet = accountList[0].ShippingStreet,
            BillingCity = accountList[0].ShippingCity
            BillingStreet = accountList[0].ShippingStreet,
            Email = accountList[0].ShippingCity
            Fax = accountList[0].ShippingStreet,
            Phone = accountList[0].ShippingCity
        )


        //Best Prctices
        Contact contactToUpdate = new Contact(
            Id = contactInstance.Id,
            MailingStreet = accountInstance.BillingStreet
            
        );

        contactsToUpdate.add(contactToUpdate);
    }

    update contactsToUpdate;
}


1. Insert contacts
2. update contacts
3. delete contacts
4. any exception?

18/04/2022:
Id is not specified in the update call

recordId => flow


Taking all the opportunities


if(close date - today  <= 3)


Close Date = 22/04/2022
Today = 19/04/2022


if(Close Date - Today <=  3) {

}