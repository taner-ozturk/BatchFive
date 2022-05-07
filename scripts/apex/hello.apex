// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);

// Notification_Event__e event = new Notification_Event__e();
// event.Message__c = 'Merhaba kartal görünümlü şahinler :) ';
// event.Source__c = 'Sharepoint Integration';
// EventBus.publish(event);



Notify_Chatter_User__e event = new Notify_Chatter_User__e();
event.Message__c = 'Merhaba Mentörlerimiz.! Sizi çok seviyoruz🥰';
event.Source__c = 'Adana';
EventBus.publish(event);


