/****************************************************************************
*Name           : LeadTriggerHandlerTest 
*Description    : Test Class to Cover LeadTrigger and LeadTriggerHandler
*
******************************************************************************
* Version       Date          Author                Description
* ----------------------------------------------------------------------------
* 1.0           03/28/2017    Nidhi Shekar          Created.
******************************************************************************/
@isTest
public class TestUpdateFieldsOnTrigger 
{
    /** Test with an existing contact **/
    static testMethod void TestOppUpdate()
    {
       Date now= Date.today();
        Test.startTest();
       Account account1 = new Account(Name='Test Account');
        insert account1;
        
         Account account2 = new Account(Name='Account Name which exceeds seventeen Characters');
        insert account2;
        
        
        Opportunity opp1=new Opportunity(Name='Test Opp1',
            AccountId=account1.Id,
            CloseDate=now,
            StageName='Proposal',
            Product_Of_Interest__c='Ethernet',
            Identifying_Characteristic__c='TestIC'          
        );
        insert opp1;
        
        Opportunity opp2=new Opportunity(Name='Test Opp2',
            AccountId=account2.Id,
            CloseDate=now,
            StageName='Proposal',
            Product_Of_Interest__c='Ethernet',
            Identifying_Characteristic__c='TestIC'                            
        );
        insert opp2;
        
        Opportunity opp3=new Opportunity(Name='Test Opp2',
            AccountId=account2.Id,
            CloseDate=now,
            StageName='Proposal',
            Identifying_Characteristic__c='TestIC' 
        );
        insert opp3;
        
        Test.stopTest();
    }
    
}