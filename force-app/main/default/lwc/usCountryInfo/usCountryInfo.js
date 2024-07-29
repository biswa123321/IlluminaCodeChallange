import { LightningElement,api } from 'lwc';

export default class UsCountryInfo extends LightningElement {
    @api countryInfo={};
    @api usCountry=false;

}