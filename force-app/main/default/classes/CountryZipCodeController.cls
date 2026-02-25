public with sharing class CountryZipCodeController {
    //New Cooments added 
    // This method will call zipcode api to get Country.
    @AuraEnabled
    public static countryResponseWrapper getCountryByZipCode(String zipCode,String countryCode) {
        countryResponseWrapper countryResponse=new countryResponseWrapper();                
        System.debug(zipCode);
        try{
            if(!String.isBlank(zipCode) && !String.isBlank(countryCode)){
                String endPoint='https://api.zippopotam.us/'+countryCode+'/'+zipCode;
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
                request.setEndpoint(endPoint);
                request.setMethod('GET');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                
                response = http.send(request); 
                system.debug('response'+response.getBody());
                
                if(response.getstatusCode() == 200){
                    if(!String.isBlank(response.getBody())){
                        //countryResponse=(countryResponseWrapper)json.deserialize(response.getbody(),countryResponseWrapper.class);
                        Map<String, Object> ObjRes = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                        countryResponse.country=(String)ObjRes.get('country');
                        countryResponse.post_code=(String)ObjRes.get('post code');
                        countryResponse.countryabbreviation=(String)ObjRes.get('country abbreviation');
                        
                        //Manupulating the place information here as the Keys are having whitespace so directly we can not map
                        String strTmp=response.getbody().toString();
                        List<String> lstStr= strTmp.split('places');
                        String strTmp2=lstStr[1];
                        String strTmp3=strTmp2.substring(4, strTmp2.length()-2);
                        System.debug('strTmp3=='+strTmp3);
                        List<String> lstPlacerecords=strTmp3.split('},');
                        List<Place> lstPlaceMap=new List<Place>();
                        Country__c country=new Country__c();
                        List<Place__c> lstPlace=new List<Place__c>();
                        
                        //if country is not US then saving the country and place records in custom Object.
                        if(countryResponse.country!='United States'){
                            country=new country__c(Name=countryResponse.country,Post_Code__c=countryResponse.post_code,countryabbreviation__c=countryResponse.countryabbreviation);
                            insert country;
                        }            
                        //iterate throug the list of places and mapping in the wrapper class and saving in place object.
                        System.debug('lstPlacerecords.size()=='+lstPlacerecords.size());
                        for(String str: lstPlacerecords){
                            System.debug('yyy=='+str.right(1));
                            if(str.right(1)!='}'){    
                                str=str+'}';
                            }
                            
                            Place objPlace=new Place();
                            System.debug('str=='+str);
                            Map<String, Object> ObjMapPlace =new Map<String, Object> ();
                            ObjMapPlace = (Map<String, Object>)JSON.deserializeUntyped(str);
                            System.debug('place name=='+ObjMapPlace.get('place name'));
                            objPlace.placename=(String)ObjMapPlace.get('place name');
                            objPlace.stateabbreviation=(String) ObjMapPlace.get('state abbreviation');
                            objPlace.state=(String)ObjMapPlace.get('state');
                            objPlace.latitude=(String)ObjMapPlace.get('latitude');
                            objPlace.longitude=(String)ObjMapPlace.get('longitude');
                            lstPlaceMap.add(objPlace);
                            if(countryResponse.country!='United States'){
                                Place__c p=new Place__c(country__c=country.Id,Name=objPlace.placename,State_Abbreviation__c=objPlace.stateabbreviation,state__c=objPlace.state,Latitude__c=objPlace.latitude,longitude__c=objPlace.longitude);
                                lstPlace.add(p);
                            }
                        }
                        countryResponse.places=lstPlaceMap;
                        if(lstPlace.size()>0){
                            insert lstPlace;
                        }
                    }
                    else{
                        countryResponse.errorMsg='No country found with the enetered Zipcode '+zipCode;
                    }                    
                }
                else{
                    countryResponse.errorMsg='Country not found. status code:'+ response.getstatusCode();
                }
            }
        }
        catch(Exception e){
            countryResponse.errorMsg=e.getMessage();
            System.debug('Error'+e);           
        }    
        return countryResponse;
    }
    
    public class countryResponseWrapper{
        @AuraEnabled public String post_code;
        @AuraEnabled public String country;
        @AuraEnabled public String countryabbreviation;
        @AuraEnabled public List<Place> places; 
        @AuraEnabled public String errorMsg;
        
    }
    public class Place {
        @AuraEnabled public String placename;
        @AuraEnabled public String longitude;
        @AuraEnabled public String state;
        @AuraEnabled public String stateabbreviation;
        @AuraEnabled public String latitude;
    }
    
    
}
