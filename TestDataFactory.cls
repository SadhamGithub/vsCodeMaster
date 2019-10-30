/**
* Author: Creation Technology Solutions
* Date: 11/01/2019
* Description: Test Data Setup for test classes.
**/
@isTest
public class TestDataFactory {
	/**
     * createAccount - Return the List of accounts based on count 
     * @param  count  
     * @return accountList - List of accounts 
    */
    public static List<Account> createAccount(Integer count){
        List<Account> accountList            = new List<Account>();

        for( Integer i=1; i<=count; i++ ){
            Account thisAccount               = new Account();
            thisAccount.Name                  = 'Anthony'+i;
            thisAccount.BillingCountry        = 'Australia';
            thisAccount.BillingState          = 'Queensland';
            thisAccount.BillingPostalCode     = '2278';
            thisAccount.BillingStreet         = 'Chelsea Manor Tunnel';
            thisAccount.BillingCity           = 'Memphis';
            accountList.add(thisAccount);
        }
        return accountList;
    }

    /**
     * createContact - Return the list of contacts with account based on count.
     * @param  count, accountId
     * @return contactList - List of contacts        
    */
    public static List<Contact> createContact(Integer count, Id accountId){
        List<Contact> contactList      = new List<Contact>();

        for( Integer i=1; i<=count; i++ ){
            Contact thisContact        = new Contact();
            thisContact.FirstName      = 'Benny';
            thisContact.LastName       = 'Jenkins'+i;
            thisContact.Email          = 'Benny_Jenkins6934@grannar.com';
            thisContact.MailingCountry = 'Russia';
            thisContact.AccountId      = accountId;
            contactList.add(thisContact);
        }
        return contactList;
    }

    /**
     * getStandardPriceBookId - Return the Sandard PriceBook Id.
     * @return standardPricebookId         
    */
    public static Id getStandardPriceBookId(){
    	Id standardPricebookId = Test.getStandardPricebookId();
    	return standardPricebookId;
    }

    /**
     * createProduct - Return the List of products
     * @param count
     * @return productList - list of products        
    */
    public static List<Product2> createProduct(Integer count){
        List<Product2> productList = new List<Product2>();

        for( Integer i=1; i<=count; i++ ){
            Product2 thisProduct    = new Product2();
            thisProduct.Name        = 'Innovation'+i;
            thisProduct.isActive    = true;
            thisProduct.Family      = 'Education';
            productList.add(thisProduct);
        }
        return productList;
    }

    /**
     * createCustomPricebook - Return the custom pricebook.
     * @param pricebookName
     * @return createNewCustomPricebook    
    */
    public static Pricebook2 createCustomPricebook(String pricebookName){
        Pricebook2 createNewCustomPricebook      = new Pricebook2();
        createNewCustomPricebook.Name            = pricebookName;
        createNewCustomPricebook.isActive        = true;
        return createNewCustomPricebook;
    }

    /**
     * createPricebookEntry - Return the custom pricebook entry.
     * @param product2Id, pricebookId, unitPriceValue
     * @return createNewcustomPricebookEntry       
    */
    public static PricebookEntry createPricebookEntry(Id product2Id, Id pricebookId, Decimal unitPriceValue){
        PricebookEntry createNewcustomPricebookEntry                = new PricebookEntry();
        createNewcustomPricebookEntry.Unitprice                     = unitPriceValue;
        createNewcustomPricebookEntry.CurrencyIsoCode               = 'EUR';
        createNewcustomPricebookEntry.Product2Id                    = product2Id;
        createNewcustomPricebookEntry.Pricebook2Id                  = pricebookId;
        createNewcustomPricebookEntry.isActive                      = true;
       return createNewcustomPricebookEntry;
    }

    /**
     * createOpportunity - Return the list of Opportunity.
     * @param count, thisaccount
     * @return opportunityList - list of opportunity.      
    */
    public static List<Opportunity> createOpportunity(Integer count,Account thisaccount){
        List<Opportunity> opportunityList      = new List<Opportunity>();

        for( Integer i=1; i<=count; i++ ){
            Opportunity thisOpportunity        = new Opportunity();
            thisOpportunity.Name               = thisaccount.Name+' Opportunity '+i;
            thisOpportunity.Amount             = 2000;
            thisOpportunity.StageName          = 'Prospecting';
            thisOpportunity.CloseDate          = System.today();
            thisOpportunity.AccountId          = thisaccount.Id; 
            opportunityList.add(thisOpportunity);
        }
        return opportunityList;
    }

    /**
     * createOpportunityLineItem - Return the opportunity line item.
     * @param opportunityId, pricebookEntryId, quantity
     * @return createNewOpportunityLineItem       
    */
    public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Id pricebookEntryId, Integer quantity){
        OpportunityLineItem createNewOpportunityLineItem = new OpportunityLineItem();
        createNewOpportunityLineItem.OpportunityId       = opportunityId;
        createNewOpportunityLineItem.Quantity            = quantity;
        createNewOpportunityLineItem.PricebookEntryId    = pricebookEntryId;
        return createNewOpportunityLineItem;
    }

    /**
     * createUser - Return the user.  
    */
    public static User createUser(){
        //Insert User Role
        UserRole newUserRole = new UserRole();
        newUserRole.Name     = 'Sales Team'; 
        insert newUserRole;

        //Insert Profile
        Profile newProfile   = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 

        String orgId         = UserInfo.getOrganizationId(); 
        String dateString    = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomId     = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName    = orgId+dateString+randomId;
        //return user 
        User thisUser               = new User();
        thisUser.FirstName          = 'Sebastian';
        thisUser.LastName           = 'Simpson';
        thisUser.Email              = 'Sebastian_Simpson1617@twace.org';
        thisUser.Username           = 'Sebastian_Simpson1617@twace.org.com';
        thisUser.ProfileId          = newProfile.Id;
        thisUser.UserRoleId         = newUserRole.Id;
        thisUser.EmailEncodingKey   = 'ISO-8859-1';
        thisUser.Alias              = uniqueName.substring(18, 23); 
        thisUser.TimeZoneSidKey     = 'America/Los_Angeles'; 
        thisUser.LocaleSidKey       = 'en_US'; 
        thisUser.LanguageLocaleKey  = 'en_US';
        thisUser.IsActive           = true;
        return thisUser;
    }
}