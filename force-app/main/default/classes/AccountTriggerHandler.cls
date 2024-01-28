/****
 * Assumption made If an account InitializeContacts__c is true and 
 * contacts are created and then made false it still has the contacts 
 * created as part of the requirment
 * 
 * and when it is made true again it will create 
 * NumberOfContactsToCreate__c number of contacts again. 
 * 
 */
public class AccountTriggerHandler implements TriggerInterface{
    public void beforeDelete(List<Sobject> oldAccList){

    }

    public void beforeInsert(List<Sobject> newAccList){
        for(Sobject acc1 : newAccList){
            checkCommonConditions((Account)acc1);
            phoneValidation((Account)acc1);
        }
    }

    public void beforeUpdate(List<Sobject> newAccList,Map<Id,Sobject> oldAccMap){
        for(Sobject acc1 : newAccList){
            Account a = (Account) acc1;
            checkCommonConditions(a);
            if(((Account)oldAccMap.get(a.Id)).Phone != a.Phone){
                phoneValidation(a);
            }
        }
    }

    public void afterDelete(List<Sobject> oldAccList){
        
    }

    public void afterInsert(List<Sobject> newAccList){
        List<Account> accToProcess = new List<Account>();
        for(Sobject acc1 : newAccList){
            Account a = (Account)acc1;
            if(a.InitializeContacts__c){
                accToProcess.add(a);
            }
        }
        system.debug('contactInitialization called'+accToProcess);
        contactInitialization(accToProcess);
    }

    public void afterUpdate(List<Sobject> newAccList,Map<Id,Sobject> oldAccMap){
        List<Account> accToProcess = new List<Account>();
        Map<Id,Account> accMapToProcess = new Map<id,Account>();
        for(Sobject acc1 : newAccList){
            Account a = (Account)acc1;
            if(a.InitializeContacts__c && ((Account)oldAccMap.get(a.Id)).InitializeContacts__c!= a.InitializeContacts__c){
                accToProcess.add(a);
            }
            if(((Account)oldAccMap.get(a.Id)).Phone!= a.Phone){
                accMapToProcess.put(a.Id,a);
            }
        }
        contactInitialization(accToProcess);
        phoneSyncInContacts(accMapToProcess);
        }

    public void checkCommonConditions(Account acc){
            if(String.IsBlank(acc.Phone)){
                acc.Phone.addError(System.Label.Mandatory_Common_Error_MSG); //Phone mandatory Condition
            }
            if(String.IsBlank(acc.BillingCountry)){
                acc.BillingCountry.addError(System.Label.Mandatory_Common_Error_MSG); //BillingCountry mandatory Condition
            }
    }

    public void phoneValidation(Account acc){ //Validating the phone format
        String phonenum =acc.Phone;
        phonenum = phonenum.replaceAll('\\s','');
        phonenum = phonenum.startsWith('+') ? phonenum.substring(1) : phonenum;
        if(String.IsBlank(phonenum) && !phonenum.startsWith('65') || phonenum.length() != 10){
            acc.Phone.addError(System.Label.Phone_Format_Error);
        }
    }

    public static void contactInitialization(List<Account> accountsToProcess){
        List<Contact> contactsToCreate = new List<Contact>();
        //ASSUMPTION MADE : If there are any Contacts present on the account 
        //already and then InitializeContacts__c is made to true we are not considering them in any form. 
        for(Account acc :accountsToProcess){
            for(Integer i = 1; i<= acc.NumberOfContactsToCreate__c; i++){
                Contact newCon = new Contact(
                    AccountId = acc.Id,
                    FirstName = acc.Name,
                    LastName = string.valueOf(i),
                    Phone=acc.Phone
                );
                contactsToCreate.add(newCon);
            }
        }
        try{
            database.insert(contactsToCreate); //Error handling changes in realtime with the respect to the Error handling mechanism.
        } catch(exception ex){
            system.debug('Error occured at '+ex.getLineNumber()+'Error is'+ex.getMessage());
            throw ex;
        }
        
    }

    public static void phoneSyncInContacts(Map<id,Account> accToProcessMap){
        List<Contact> ConList = [SELECT ID,Phone,AccountId from Contact where AccountId in :accToProcessMap.keySet()];
        for(Contact con : ConList){
            con.Phone = accToProcessMap.get(con.AccountId).Phone;
        }
        database.update(ConList);
    }
}