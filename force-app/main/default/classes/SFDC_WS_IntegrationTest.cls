@isTest
public with sharing class SFDC_WS_IntegrationTest {

@isTest
static void getcurrentweatherInfoTest() {
        //Set the mock callout or mock reponse
        Test.setMock(HttpCalloutMock.class, new SFDC_WS_IntegrationMock());

        Test.startTest();
        SFDC_WS_Integrations.getcurrentweatherInfo('New York');
        Test.stoptest();
    }
}