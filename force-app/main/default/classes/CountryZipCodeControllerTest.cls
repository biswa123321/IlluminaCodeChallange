@isTest
public with sharing class CountryZipCodeControllerTest {
    
    @isTest
    public static void getCountryByZipCodeTest(){       
        Test.setMock(HttpCalloutMock.class, new CountryZipCodeControllerMock()); 
        Test.StartTest();        
        CountryZipCodeController.countryResponseWrapper response=CountryZipCodeController.getCountryByZipCode('99950','mx');       
        Test.stopTest();
        System.assertEquals(response.countryabbreviation, 'MX');
    }   
}