@isTest
global with sharing class CountryZipCodeControllerMock implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('https://api.zippopotam.us/mx/99950', request.getEndpoint());
        System.assertEquals('GET', request.getMethod());
        String resBody='{"post code": "99950", "country": "Mexico", "country abbreviation": "MX", "places": [{"place name": "El Rescoldo", "longitude": "-103.1", "state": "Zacatecas", "state abbreviation": "ZAC", "latitude": "21.4667"}]}';

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(resBody);
        response.setStatusCode(200);
        response.setStatus('OK');     
        return response; 
    }

}