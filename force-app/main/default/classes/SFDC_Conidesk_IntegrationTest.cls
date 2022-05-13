@isTest
public class SFDC_Conidesk_IntegrationTest {
	
    @isTest
    static void getBitcoinPriceTest() {
        Test.setMock(HttpCalloutMock.class, new SFDC_Conidesk_IntegrationMock());
        
        SFDC_Conidesk_Integration.getBitcoinPrice();
    }
}