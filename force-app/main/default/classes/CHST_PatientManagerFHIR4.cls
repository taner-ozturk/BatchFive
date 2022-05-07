@RestResource(urlMapping='/Patientfhir4/*')
global with sharing class CHST_PatientManagerFHIR4 {
    private static String createdById = '005050000022sIvAAI';
    private static String noProviderId = '1825';
    
    @HttpPatch
    global static String patientMergeFHIR4(String toMRN, String fromMRN, String visitId) {
        String responseStr;
        Map<String, Object> responseMap = new Map<String, Object>();
        Savepoint sp = Database.setSavepoint();
        
        try {
            if(toMRN == null || toMRN == '' || fromMRN == null || fromMRN == '') {
                responseMap.put('success', 'false');
                responseMap.put('message', 'Bad Request');
                responseMap.put('errorCode', '400');
            } else {
                Boolean toPatientFound = false;
                Boolean fromPatientFound = false;
                Account toPatient;
                Account fromPatient;
                List<Account> ehrPatientList = [SELECT Id, MRN__c FROM Account WHERE MRN__c =: toMRN OR MRN__c =: fromMRN];
                for(Account patientEHR : ehrPatientList){
                    if(patientEHR.MRN__c == toMRN) {
                        toPatient = patientEHR;
                        toPatientFound = true;
                    }
                    if(patientEHR.MRN__c == fromMRN) {
                        fromPatientFound = true;
                        fromPatient = patientEHR;
                    }
                }
                if(!toPatientFound) {
                    responseMap.put('success', 'false');
                    responseMap.put('message', 'Patient with the provided toMRN not found');
                    responseMap.put('errorCode', '400');
                } else if (!fromPatientFound) {
                    responseMap.put('success', 'false');
                    responseMap.put('message', 'Patient with the provided fromMRN not found');
                    responseMap.put('errorCode', '400');
                } else {
                    if(String.isBlank(visitId)) { // processing all child objects
                        // Repoint Encounters and Procedures
                        updateEncountersProcedures(toPatient, fromPatient, null);
                        
                        // Repoint Referrals
                        updateReferrals(toPatient, fromPatient);
                       
                        // Repoint Patient Contacts
                        updatePatientContacts(toPatient, fromPatient);
                        
                        // Repoint Task Records
                        updateTaskRecords(toPatient, fromPatient);
                        
                        // Repoint Patient Communication logs
                        updatePatientExpComLogs(toPatient, fromPatient);
                        
                        //update from patient to Patient.Id
                        toPatient.Merged_From_Patient__c = fromPatient.Id;
                        fromPatient.Merged_To_Patient__c = toPatient.Id;
                        
                        update toPatient;
                        update fromPatient;
                        
                        responseMap.put('success', 'true');
                        responseMap.put('message', 'Encounters and child objects processed.');
                        responseMap.put('errorCode', '200');
                        responseMap.put('toPatient', toPatient);
                        responseMap.put('fromPatient', fromPatient);
                    } else { // processing only encouter for visitId
                        Boolean status = updateEncountersProcedures(toPatient, fromPatient, visitId);
                        if (status) {
                            responseMap.put('success', 'true');
                            responseMap.put('success', '200');
                            responseMap.put('message', 'Encounter for the provided visit Id processed');
                        } else {
                            responseMap.put('success', 'false');
                            responseMap.put('message', 'Encounter for the provided visit Id not found');
                            responseMap.put('errorCode', '400');
                        }
                    }
                }
            }
        }   catch(Exception ex) {
            Database.rollback(sp);
            Logger.log(ex);
            responseMap.put('success', 'false');
            responseMap.put('message', ex.getMessage());
            responseMap.put('errorCode', '500');
        }
        responseStr = JSON.serialize(responseMap);
        return responseStr;
    }
    
    private static Boolean updateEncountersProcedures(Account toPatient, Account fromPatient, String visitId) {
        Boolean status = false;
        List<ClinicalEncounter> ehrList = null;
        if ( visitId != null ) {
            ehrList = [SELECT Id FROM ClinicalEncounter WHERE Epic_CSN__c =: visitId LIMIT 1];
        } else {
            ehrList = [SELECT Id FROM ClinicalEncounter WHERE PatientId =: fromPatient.Id];           
        }
        if(ehrList.size() > 0) {
            List<ClinicalEncounter> ehrListUpdate = new List<ClinicalEncounter>();
            for(ClinicalEncounter ehrENC : ehrList) {
                ehrENC.Merged_From_Patient__c = fromPatient.Id;
                ehrENC.PatientId = toPatient.Id;
                ehrListUpdate.add(ehrENC);
                updateProcedures(toPatient, fromPatient, ehrENC);
            }
            update ehrListUpdate;
            status = true;
        }
        return status;
    }
    
    private static void updateProcedures(Account toPatient, Account fromPatient, ClinicalEncounter encounter) {
        List<Medical_Procedure__c> ehrListEnc = [SELECT Id FROM Medical_Procedure__c WHERE Patient__c =: fromPatient.Id AND Clinical_Encounter__c =: encounter.Id];
        if(ehrListEnc.size() > 0) {
            List<Medical_Procedure__c> ehrListEncUpdate = new List<Medical_Procedure__c>();
            for(Medical_Procedure__c ehrProcedure : ehrListEnc) {
                ehrProcedure.Merged_From_Patient__c = fromPatient.Id;
                ehrProcedure.Patient__c = toPatient.Id;
                ehrProcedure.Clinical_Encounter__c = encounter.Id;
                ehrListEncUpdate.add(ehrProcedure);
            }
            update ehrListEncUpdate;
        }
    }
    
    private static void updatePatientContacts(Account toPatient, Account fromPatient) {
        List<Account> contactList = [SELECT Id FROM Account WHERE Patient__c =: fromPatient.Id];
        if(contactList.size() > 0) {
            for(Account ehrPatientContact : contactList) {
                ehrPatientContact.Merged_From_Patient__c = fromPatient.Id;
                ehrPatientContact.Patient__c = toPatient.Id;
            }
            update contactList;
        }
    }
    
    private static void updateTaskRecords(Account toPatient, Account fromPatient) {
        // Get list of all the tasks records related to the Person Account associated with From Merged Patient
        List<Task> mergedTaskList= [SELECT Id,WhatId,Five9__Five9SessionId__c,WhoId FROM task where WhatId =: fromPatient.Id];
        if(mergedTaskList.size() > 0) {
            List<Task> repointTaskList = new List<Task>();
            for(Task tsk :mergedTaskList) {
                if(tsk.Five9__Five9SessionId__c != null) {
                    //tsk.IsMerged__c = true; 
                    tsk.WhatId = toPatient.Id;
                    if(tsk.WhoId != null) {
                        tsk.WhoId = toPatient.PersonContactId;
                    }    
                    repointTaskList.add(tsk);
                }
            }
            update repointTaskList;
        }
    }
    
    private static void updatePatientExpComLogs(Account toPatient, Account fromPatient) {
        List<Patient_Exp_Communication_Log__c> patientExpComLogs = [SELECT Id FROM Patient_Exp_Communication_Log__c WHERE Patient__c =: fromPatient.Id];
        if(patientExpComLogs.size() > 0) {
            for(Patient_Exp_Communication_Log__c patientExpComLog : patientExpComLogs){
                patientExpComLog.Patient__c = toPatient.Id;
                patientExpComLog.Merged_From_Patient__c = fromPatient.Id;
            }                   
            update patientExpComLogs;
        }
    }    
    
    private static void updateReferrals(Account toPatient, Account fromPatient) {
        List<EHR_Referral__c> ehrList = [SELECT Id FROM EHR_Referral__c WHERE Account__c =: fromPatient.Id];
        if(ehrList.size() > 0) {
            List<EHR_Referral__c> ehrListUpdate = new List<EHR_Referral__c>();
            for(EHR_Referral__c ehrRef : ehrList) {
                ehrRef.Merged_From_Pt__c = fromPatient.Id; 
                ehrRef.Account__c = toPatient.Id;
                ehrListUpdate.add(ehrRef);
            }
            update ehrListUpdate;
        }
    }
    
    @HttpPost    
    global static String encounterProviderDiagnosis(String encounterId, List<String> facilityRelation, List<HealthCareDiagnosis> healthCareDiagnosisList, List<String> providerEpicSer,
                                                    String patientId, String currentPCPID, List<PersonLanguage> personLanguageList) {
        Map<String, Object> responseMap = new Map<String, Object>();
        String responseStr = null;
        Savepoint sp = Database.setSavepoint();
        List<HealthCareDiagnosis> hcList = null;
        List<Clinical_Encounter_Diagnosis__c> encounterDiagnosisList = null;
        try {    
            if (!(String.isBlank(patientId))) {
                responseMap.put('patientId', patientId);
                responseMap.put('currentPCPID', currentPCPID);     
                responseMap.put('personLanguageList', personLanguageList);
                patientLangProvider(patientId, currentPCPID,  personLanguageList);
            } else {
                // processing HealthCareDiagnosis
                if (healthCareDiagnosisList.size() > 0) {
                    Set<String> records = new Set<String>(); 
                    for(HealthCareDiagnosis hcd : healthCareDiagnosisList) {
                        if (!(String.isBlank(hcd.Code__c))) {
                            records.add(hcd.Code__c);
                        }
                    }
                    hcList = [SELECT Id,Code__c,Name,Code,CodeDescription,CodeType FROM HealthCareDiagnosis WHERE Code__c IN :records];
                    //adding new HealthDiagnosis object to list and upserting it.
                    for(HealthCareDiagnosis newObj : healthCareDiagnosisList) {
                        Boolean isNew = true;
                        for(HealthCareDiagnosis oldObj : hcList) {
                            if (newObj.Code__c == oldObj.Code__c) {
                                isNew = false;
                            } 
                        }
                        if (isNew) {
                            hcList.add(newObj);
                        }
                    }
                    //Database.UpsertResult[] results = Database.upsert(hcList, HealthCareDiagnosis.Id);
                    upsert hcList;
                    encounterDiagnosisList = [SELECT Id FROM Clinical_Encounter_Diagnosis__c WHERE Clinical_Encounter__c =: encounterId];
                    delete encounterDiagnosisList;
                    encounterDiagnosisList = new List<Clinical_Encounter_Diagnosis__c>();
                    for(HealthCareDiagnosis healthCareDiagnosis : hcList) {
                        Clinical_Encounter_Diagnosis__c encounterDiagnosis = new Clinical_Encounter_Diagnosis__c();
                        encounterDiagnosis.Clinical_Encounter_Diagnosis_ID__c = encounterId +'-'+ healthCareDiagnosis.Id;
                        encounterDiagnosis.Healthcare_Diagnosis__c = healthCareDiagnosis.Id;
                        encounterDiagnosis.Clinical_Encounter__c = encounterId; 
                        encounterDiagnosisList.add(encounterDiagnosis);
                    }
                    insert encounterDiagnosisList;
                }
                // Processing Encounter Providers relationship.
                if (providerEpicSer.size() > 0) {
                    String visitingId =  null;
                    String attendingId =  null;
                    String referralId =  null;
                    String visitingType =  'Visiting';
                    String attendingType =  'Attending';
                    String referralType =  'Referring';
                    for(String id : providerEpicSer) {
                        if (!(String.isBlank(id))) {
                            String[] tmpArr = id.split('-');
                            String tmpId = tmpArr[0];
                            String tmpType = tmpArr[1];
                            if (tmpType == visitingType) {
                                visitingId = tmpId;
                            } else if (tmpType == attendingType) {
                                attendingId = tmpId;
                            } else if (tmpType == referralType) {
                                referralId = tmpId;
                            }
                        }
                    }                
                    if (visitingId != null) {
                        updateEncounterProviderContact(encounterId,visitingId,visitingType);
                    }
                    if (attendingId != null) {
                        updateEncounterProviderContact(encounterId,attendingId,attendingType);
                    }
                    if (referralId != null) {
                        updateEncounterProviderContact(encounterId,referralId,referralType);
                    } 
                }
                // Processing Encounter Facility dates.
                if (facilityRelation.size() > 0) {
                    String hospitalArrivalTime =  null;
                    String hospitalDepartureTime =  null;
                    String hospitalizePeriodStart =  null;
                    String hospitalizePeriodEnd =  null;                    
                    for(String relation : facilityRelation) {
                        String[] tmpArr = relation.split('#');
                        if (tmpArr.size() == 2) {
                            String name = tmpArr[0];
                            String value = tmpArr[1];
                            if (name == 'hospitalArrivalTime') {
                                hospitalArrivalTime = value;
                            } else if (name == 'hospitalDepartureTime') {
                                hospitalDepartureTime = value;
                            } else if (name == 'hospitalizePeriodStart') {
                                hospitalizePeriodStart = value;
                            } else if (name == 'hospitalizePeriodEnd') {
                                hospitalizePeriodEnd = value;
                            } 
                        }
                    } 
                    Clinical_Encounter_Facility__c[] clinicalEncounterFacilityArr = [SELECT Id FROM Clinical_Encounter_Facility__c WHERE Clinical_Encounter__c =:encounterId];
                    if ( clinicalEncounterFacilityArr.size() > 0) { // update existinh encounter facility relationship.
                        Clinical_Encounter_Facility__c clinicalEncounterFacility = clinicalEncounterFacilityArr[0];
                        populdateEncounterFacility(clinicalEncounterFacility,hospitalArrivalTime,hospitalDepartureTime,hospitalizePeriodStart,hospitalizePeriodEnd);
                        update clinicalEncounterFacility;
                    } else { // insert new encounter facility relationship as it does not exist.
                        Clinical_Encounter_Facility__c clinicalEncounterFacility = new Clinical_Encounter_Facility__c();
						clinicalEncounterFacility.Clinical_Encounter__c = encounterId;
                        clinicalEncounterFacility.Clinical_Encounter_Facility_ID__c = encounterId;
                        populdateEncounterFacility(clinicalEncounterFacility,hospitalArrivalTime,hospitalDepartureTime,hospitalizePeriodStart,hospitalizePeriodEnd);
                        clinicalEncounterFacilityArr.add(clinicalEncounterFacility);
                        insert clinicalEncounterFacilityArr;
                    }
                    responseMap.put('facilityRelation', clinicalEncounterFacilityArr);
                }
                responseMap.put('success', 'true');
                responseMap.put('Incoming', healthCareDiagnosisList);
                responseMap.put('success', '200');
                responseMap.put('encounterId', encounterId);    
                responseMap.put('Outgoing', hcList); 
                responseMap.put('encounterDiagnosisList', encounterDiagnosisList); 
                responseMap.put('providerEpicSer', providerEpicSer);  
               
            }

        }   catch(Exception ex) {
            Database.rollback(sp);
            Logger.log(ex);
            responseMap.put('success', 'false');
            responseMap.put('message', ex.getMessage());
            responseMap.put('errorCode', '500');
        }
        responseStr = JSON.serialize(responseMap);
        return responseStr;
        //return 'This is a test for '+companyName[0]+companyName[1]+caseType;
    }
    
    private static void populdateEncounterFacility(Clinical_Encounter_Facility__c clinicalEncounterFacility, String hospitalArrivalTime, 
                                                   String hospitalDepartureTime, String hospitalizePeriodStart, String hospitalizePeriodEnd){
        if (hospitalArrivalTime != null) {
           clinicalEncounterFacility.Arrival_Time__c = toDateTime(hospitalArrivalTime);
        }                                          
        if (hospitalDepartureTime != null) {
            clinicalEncounterFacility.Departure_Time__c = toDateTime(hospitalDepartureTime);
        }
        if (hospitalizePeriodStart != null) {
            clinicalEncounterFacility.Admission_Date__c = toDateTime(hospitalizePeriodStart);
        }
        if (hospitalizePeriodEnd != null) {
           clinicalEncounterFacility.Discharge_Date__c = toDateTime(hospitalizePeriodEnd);
        }
    }
    
    private static DateTime toDateTime(String DateTimevalue) {
        List<String> DateAndTimeList = DateTimevalue.split('T');
        List<String> dayList = DateAndTimeList[0].split('-');
        List<string> timeList = DateAndTimeList[1].split(':');
        DateTime dt = DateTime.newInstance(Integer.valueOf(dayList[0]),Integer.valueOf(dayList[1]),Integer.valueOf(dayList[2]),
                                           Integer.valueOf(timeList[0]),Integer.valueOf(timeList[1]),Integer.valueOf(timeList[2]));
        return dt;
    }
    private static void updateEncounterProviderContact(String encounterId,String epicSer, String providerType) {
        Contact[] contacts = [SELECT Id FROM Contact WHERE Epic_SER__c =:epicSer]; 
        Contact contact = null;
        if ( contacts.size() > 0) {
            contact = contacts[0];
        } else {
            contacts = [SELECT Id FROM Contact WHERE Epic_SER__c =: noProviderId]; 
            if ( contacts.size() > 0) {
                contact = contacts[0];
            }
        }
        Clinical_Encounter_Provider__c[] clinicalEncounterProviders = [SELECT Id,Provider_Type__c,Provider__c FROM Clinical_Encounter_Provider__c WHERE Clinical_Encounter__c =:encounterId and Provider_Type__c =:providerType];
        if ( clinicalEncounterProviders.size() > 0) {
            Clinical_Encounter_Provider__c clinicalEncounterProvider = clinicalEncounterProviders[0];
            // updating existing encounter provider relationship as it exits.
            if (contact.Id != clinicalEncounterProvider.Provider__c) {
                //clinicalEncounterProvider.ClinicalEncounterId = encounterId;
                //clinicalEncounterProvider.Provider_Type__c = providerType;             
                clinicalEncounterProvider.Provider__c = contact.Id;
                update clinicalEncounterProvider;
            }
        } else { // insert new encounter provider relationship as it does not exist.
            Clinical_Encounter_Provider__c clinicalEncounterProvider = new Clinical_Encounter_Provider__c();
            clinicalEncounterProvider.Clinical_Encounter__c = encounterId;
            clinicalEncounterProvider.Provider_Type__c = providerType;             
            clinicalEncounterProvider.Provider__c = contact.Id;
            clinicalEncounterProvider.Clinical_Encounter_Provider_ID__c = encounterId +'-'+ providerType;
            insert clinicalEncounterProvider;
        }
    }
    
    private static void updateEncounterProvider(String encounterId,String epicSer, String providerType) {
        HealthcareProvider[] healthcareProviders = [SELECT Id,Name,PractitionerId FROM HealthcareProvider WHERE PractitionerId IN (SELECT Id FROM Contact WHERE Epic_SER__c =:epicSer)]; 
        HealthcareProvider healthcareProvider = null;
        if ( healthcareProviders.size() > 0) {
            healthcareProvider = healthcareProviders[0];
        } else {
            healthcareProviders = [SELECT Id, Name,PractitionerId FROM HealthcareProvider WHERE PractitionerId IN (SELECT Id FROM Contact WHERE Epic_SER__c =: noProviderId)]; 
            if ( healthcareProviders.size() > 0) {
                healthcareProvider = healthcareProviders[0];
            }
        }
        ClinicalEncounterProvider[] clinicalEncounterProviders = [SELECT Id,Provider_Type__c,PractitionerId FROM ClinicalEncounterProvider WHERE ClinicalEncounterId =:encounterId and Provider_Type__c =:providerType];
        if ( clinicalEncounterProviders.size() > 0) {
            ClinicalEncounterProvider clinicalEncounterProvider = clinicalEncounterProviders[0];
            // updating existing encounter provider relationship as it exits.
            if (healthcareProvider.Id != clinicalEncounterProvider.PractitionerId) {
                //clinicalEncounterProvider.ClinicalEncounterId = encounterId;
                //clinicalEncounterProvider.Provider_Type__c = providerType;             
                clinicalEncounterProvider.PractitionerId = healthcareProvider.Id;
                update clinicalEncounterProvider;
            }
        } else { // insert new encounter provider relationship as it does not exist.
            ClinicalEncounterProvider clinicalEncounterProvider = new ClinicalEncounterProvider();
            clinicalEncounterProvider.ClinicalEncounterId = encounterId;
            clinicalEncounterProvider.Provider_Type__c = providerType;             
            clinicalEncounterProvider.PractitionerId = healthcareProvider.Id;
            clinicalEncounterProvider.Clinical_Encounter_Provider_ID__c = encounterId +'-'+ providerType;
            insert clinicalEncounterProvider;
        }
    }
    
    private static void patientLangProvider(String patientId, String currentPCPID, List<PersonLanguage> personLanguageList) {
        //creating patient's pcp relationship.
        if (!(String.isBlank(currentPCPID))) {
            String patientContactId = null;
            String providerContactId = null;
            
            ///Contact[] patientContact=[SELECT Id FROM Contact WHERE AccountId =: patientId];
            
            Contact[] providerContact=[SELECT Id FROM Contact WHERE Epic_SER__c =: currentPCPID];
     
            if(providerContact.size() > 0) {
                providerContactId = providerContact[0].Id;
            } else {
                providerContact=[SELECT Id FROM Contact WHERE Epic_SER__c =: noProviderId];
                providerContactId = providerContact[0].Id;
            }          
            List<Account> ehrPatientList = [SELECT Id FROM Account WHERE Id =: patientId];
            Account patient = null;
            for(Account patientEHR : ehrPatientList) {
                patient = patientEHR;
            }
            if (patient != null) {
                patient.Current_Primary_Care_Provider__c = providerContactId;
                update patient;
            } 
        }
        // deleting existing provider language and creating newones
        if(personLanguageList.size() > 0) {
            List<PersonLanguage> personLangDeleteList = [SELECT Id FROM PersonLanguage where IndividualId =: patientId]; 
            if(personLangDeleteList.size() > 0) {
                delete personLangDeleteList;
            }
            upsert personLanguageList;                    
        }
    }            
       
}
/*                List<String> resultList = new List<String>();
for(Integer i = 0; i < results.size(); i++) {
if( results[i].isSuccess() ) {
if(results[i].isCreated()) {
resultList.add(hcList[i].Id +' was created');
} else {
resultList.add(hcList[i].Id +' was updated');
}
}
} */