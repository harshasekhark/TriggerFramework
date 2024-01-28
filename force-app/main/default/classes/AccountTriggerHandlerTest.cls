@isTest
public class AccountTriggerHandlerTest {
@isTest
    public static void InsertAccwithInitialize(){
        Trigger_conf__c tc = new Trigger_conf__c(name = 'Account',TiggerHandlerClass__c = 'AccountTriggerHandler',SkipTriggerUsernames__c='harshasekhar@gmail.com.harsha');
        insert tc;
        Account acc1 = new Account();
        acc1.Name = 'DataImp';
        acc1.Phone='6599999999';
        acc1.BillingCountry='Singapore';
        acc1.InitializeContacts__c = true;
        acc1.NumberOfContactsToCreate__c = 4;
        Test.StartTest();
        insert acc1;
        
        List<Contact> conList = [SELECT id from contact where accountId = :acc1.Id];
        System.assertEquals(4,conList.size(),'Contacts Should be created correctly');
        
        acc1.InitializeContacts__c = false;
        acc1.Phone='6599999997';
        update acc1;
        List<Contact> conList3 = [SELECT id,Phone from contact where accountId = :acc1.Id];
        System.assertEquals(String.valueOf(conList3[0].Phone),'6599999997','Contacts Should be updated with phone correctly');
        acc1.InitializeContacts__c = true;
        update acc1;
        
        List<Contact> conList2 = [SELECT id from contact where accountId = :acc1.Id];
        System.assertEquals(8,conList2.size(),'Contacts Should be created correctly');
        Test.StopTest();
    }
    
    
    @isTest
    public static void errorCaseBillingCountryTest(){
        Trigger_conf__c tc = new Trigger_conf__c(name = 'Account',TiggerHandlerClass__c = 'AccountTriggerHandler');
        insert tc;
        Account acc1 = new Account();
        acc1.Name = 'DataImp';
        acc1.Phone='6599999999';
        //acc1.BillingCountry='Singapore';
        acc1.InitializeContacts__c = true;
        acc1.NumberOfContactsToCreate__c = 4;
        Test.StartTest();
        try{
            insert acc1;
            System.assert(false,'Expected to throw error');
        }catch(exception ex){
            System.assert(true,'Expected error is thrown');
        }
        
        Test.StopTest();
    }
    
    @isTest
    public static void errorCasePhoneTest(){
        Trigger_conf__c tc = new Trigger_conf__c(name = 'Account',TiggerHandlerClass__c = 'AccountTriggerHandler');
        insert tc;
        Account acc1 = new Account();
        acc1.Name = 'DataImp';
        //acc1.Phone='6599999999';
        acc1.BillingCountry='Singapore';
        acc1.InitializeContacts__c = true;
        acc1.NumberOfContactsToCreate__c = 4;
        Test.StartTest();
        try{
            insert acc1;
            System.assert(false,'Expected to throw error');
        }catch(exception ex){
            System.assert(true,'Expected error is thrown');
        }
        
        Test.StopTest();
    }
    
    @isTest
    public static void errorCasePhonelengthTest(){
        Trigger_conf__c tc = new Trigger_conf__c(name = 'Account',TiggerHandlerClass__c = 'AccountTriggerHandler');
        insert tc;
        Account acc1 = new Account();
        acc1.Name = 'DataImp';
        acc1.Phone='65999912349999';
        acc1.BillingCountry='Singapore';
        acc1.InitializeContacts__c = true;
        acc1.NumberOfContactsToCreate__c = 4;
        Test.StartTest();
        try{
            insert acc1;
            System.assert(false,'Expected to throw error');
        }catch(exception ex){
            System.assert(true,'Expected error is thrown');
        }
        
        Test.StopTest();
    }
    
    @isTest
    public static void errorCaseWrongPhoneTest(){
        Trigger_conf__c tc = new Trigger_conf__c(name = 'Account',TiggerHandlerClass__c = 'AccountTriggerHandler');
        insert tc;
        Account acc1 = new Account();
        acc1.Name = 'DataImp';
        acc1.Phone='2103030300';
        acc1.BillingCountry='Singapore';
        acc1.InitializeContacts__c = true;
        acc1.NumberOfContactsToCreate__c = 4;
        Test.StartTest();
        try{
            insert acc1;
            System.assert(false,'Expected to throw error');
            delete acc1;
        }catch(exception ex){
            System.assert(true,'Expected error is thrown');
        }
        
        Test.StopTest();
    }
}