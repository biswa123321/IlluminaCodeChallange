import { LightningElement,wire,track } from 'lwc';
import getCountryByZipCode from '@salesforce/apex/CountryZipCodeController.getCountryByZipCode';


export default class ZipCodeContainer extends LightningElement {

    @track zipCode;
    @track errorMsg;
    @track responseCountryInfo={};
    @track countryCode='us';// setting countryCode value 'US' as default beacuse in Assesment its not mentioned that the Country code is required for the API.

    isUSCountry= false;
    showCountrySection=false;
    
    setZipCode(event){
        this.errorMsg='';
        this.showCountrySection=false;              
        this.zipCode=event.target.value;
    }
    setcountryCode(event){
        this.errorMsg='';
        this.showCountrySection=false;              
        this.countryCode=event.target.value;
    }

    FindCountry(){
        if(this.zipCode=='' || this.zipCode==undefined){
            return;
        }
        
        getCountryByZipCode({zipCode: this.zipCode,countryCode:this.countryCode}).then(response => {
            if(response.errorMsg!=null)  {
                this.errorMsg=response.errorMsg; 
                this.showCountrySection=false;              
                //this.application = JSON.parse(JSON.stringify(response[0]));
            } else {
                this.responseCountryInfo=JSON.parse(JSON.stringify(response));
                this.showCountrySection=true;
                if(this.responseCountryInfo.country=='United States'){
                    this.isUSCountry=true;
                }
                else{
                    this.isUSCountry=false;
                }
                console.log(JSON.parse(JSON.stringify(response)));
                //this.template.querySelector('c-apus-navigation-tool').navigateToDifferentPage(null, this.currentPageApiName)
            }

        }).catch(error => {
            this.errorMsg=error;
            console.error(error);
        });
  
    }
}