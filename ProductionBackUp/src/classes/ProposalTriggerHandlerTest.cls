/****************************************************************************
*Name           : ProposalTriggerHandlerTest
*Description    : Test Class to Cover ProposalTriggerHandler and ProposalTrg
*
******************************************************************************
* Version       Date          Author                Description
* ----------------------------------------------------------------------------
* 1.0           03/31/2017   Kumar manegalla          Created.
 
******************************************************************************/
@isTest
public class ProposalTriggerHandlerTest{
  
    /* Test method to cover ProposalTrg and ProposalTriggerHandler */
    public static testMethod void ProposalTriggertestMethod()
    {
        Test.startTest();
        Account account1 = new Account(Name='Test Account');
        insert account1;
        
        Opportunity opp1 = new Opportunity(Name='Test Opp1',
        AccountId = account1.Id,
        CloseDate = Date.today(),
        StageName='Proposal',
        Product_Of_Interest__c='Ethernet',
        Identifying_Characteristic__c='TestIC'          
        );
        insert opp1;
        
        Proposal__c prpRec = new Proposal__c();
        prpRec.Opportunity__c = opp1.Id;
        prpRec.Status__c = 'Signed';
        prpRec.Name = ''+opp1.Id;
        insert prpRec; 
        update prpRec;
        prpRec.Status__c = 'Sent to customer';
        update prpRec;
        Test.stopTest();
    }
}