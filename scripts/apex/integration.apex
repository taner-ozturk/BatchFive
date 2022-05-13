SFDC_Conidesk_Integration.getBitcoinPrice();
SFDC_WS_Integrations.getCurrentWeatherInfo('Houston');

UsersCallout.fetchAllUsers();
UsersCallout.checkContactAndCreate('aaryan_kakkar@considine.info');
UsersCallout.createUserInGoREST('Betty', 'bet@gmail.com', 'female', 'active');


// Account accountInstance = [SELECT Id, Name, Type, First_Name__c, Company_Name__c FROM Account LIMIT 1];
// System.debug('accountInstance:' + accountInstance);
// String accountJSONString = JSON.serialize(accountInstance);
// System.debug('accountJSONString:' + accountJSONString);

// String modifiedString = '{"attributes":{"type":"Account","url":"/services/data/v54.0/sobjects/Account/0015j00000eQFibAAG"},"Id":"0015j00000eQFibAAG","Name":"Account From WorkBench","Type":"Customer - Direct", "CompanyName" : "My Company", "FirstName" : "My Name"}';
// Account deserializedAccount = (Account) JSON.deserialize(modifiedString, Account.class);
// System.debug('deserializedAccount:' + deserializedAccount);


// List<Account> accList = new List<Account>();

// Map<Id, Account> accountMap = new Map<Id, Account>(accList); 

// Map<Id, Account> accountMap = (Map<Id, Account>)(accList); 

