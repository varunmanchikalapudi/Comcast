/****************************************************************************
*Name           : LeadTriggerHandlerTest 
*Description    : Test Class to Cover LeadTrigger and LeadTriggerHandler
*
******************************************************************************
* Version       Date          Author                Description
* ----------------------------------------------------------------------------
* 1.0           03/28/2017    Nidhi Shekar          Created.
* 1.1           07/25/2017    Kumar manegalla       Edited.
******************************************************************************/
@isTest
public class TestMapFieldsOnLeadConversionTrigger  {
  
    /* Test method to cover LeadTrigger and LeadTriggerHandler */
    public static testMethod void LeadConvertTest()
    {
      Account account = new Account();
        account.Name='Test Account1';
        account.Amdocs_Account_ID__c= '1234';
        account.Amdocs_Parent_Account_ID__c = '2345';
        insert account;  
     
        /* Inserting Lead record with Product_of_Interest__c blank*/
        Lead ledRec = new Lead();
        ledRec.FirstName = 'Test First';
        ledRec.LastName = 'Test Last';
        ledRec.Company = 'Test Co';
        ledRec.PostalCode = '45685';
        ledRec.Phone  = '89264856668';
        ledRec.Email  = 'test@testmail.com';
        ledRec.Customer_ID__c = '123';
        insert ledRec;
       // HelperLeadOpportunityConversion ledHelper = new HelperLeadOpportunityConversion();
        //ledHelper.afterInsert(new List<Lead>{ledRec});
              /* Inserting Lead record with Product_of_Interest__c */
        Lead ledPrdInterest = new Lead();
        ledPrdInterest.FirstName = 'Test First';
        ledPrdInterest.LastName = 'Test Last';
        ledPrdInterest.Company = 'Test Co';
        ledPrdInterest.PostalCode = '45685';
        ledPrdInterest.Phone  = '89264856668';
        ledPrdInterest.Email  = 'test@testmail.com';
        ledPrdInterest.Product_of_Interest__c = 'Cloud Solutions';
        ledPrdInterest.Customer_ID__c = '123';
        insert ledPrdInterest;
     test.startTest();
             Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(ledRec.Id);
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted = true limit 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            lc.setLeadId(ledPrdInterest.Id); 
            lc.setConvertedStatus(convertStatus.MasterLabel);
            lcr = Database.convertLead(lc);
        test.stopTest();              
    }
    public static testMethod void UpdateLeadOwnerTest()
    {
        Lead leadOwner = new Lead();
        List<User> reps = new List<User> ([select Id, IsActive from User where IsActive = true]);
        User activeuser = reps.get(0);
        List<id> Ownerid = new List<id>();
        leadOwner.FirstName = 'Test First';
        leadOwner.LastName = 'Test Last';
        leadOwner.Company = 'Test Co';
        leadOwner.PostalCode = '45685';
        leadOwner.Phone  = '89264856668';
        leadOwner.Email  = 'test@testmail.com';
        leadOwner.Product_of_Interest__c = 'Cloud Solutions';
        leadOwner.Customer_ID__c = '123';
        leadOwner.OwnerId = activeuser.id;
        insert leadOwner;
    }
    static testMethod void LeadConversionTest()
    {
      Account account = new Account();
        account.Name='Test Account';
        account.Amdocs_Account_ID__c= '123';
        account.Amdocs_Parent_Account_ID__c = '234';
        insert account;  
       // create a Lead
 Lead ledRec = new Lead();
        ledRec.FirstName = 'Test First';
        ledRec.LastName = 'Test Last';
        ledRec.Company = 'Test Co';
        ledRec.PostalCode = '45685';
        ledRec.Phone  = '89264856668';
        ledRec.Email  = 'test@testmail.com';
        ledRec.Customer_ID__c = '123';
        insert ledRec;
             
    }
 }