/****************************************************************************
*Name           : CanvasPraposalTest 
*Description    : Test Class to Cover CanvasProposalcnt and canvasproposalviewcnt
*
******************************************************************************
* Version       Date          Author                        Description
* ----------------------------------------------------------------------------
* 1.0           07/25/2017    Pradeepkumar  Manegalla       Created.
******************************************************************************/
@isTest
public class CanvasPraposalTest
{
    /** Test with an existing contact **/
     
    static testMethod void TestOppUpdate()
    {
        Account account1 = new Account(Name='Test Account');
        insert account1;
       
        Contact con = new contact(LastName='test',FirstName='Con',AccountId = account1.id);
        insert con;

        
        Opportunity opp1 = new Opportunity(Name='Test Opp1',
            AccountId = account1.Id,
            CloseDate = Date.today(),
            StageName='Proposal',
            Product_Of_Interest__c='Ethernet',
            Identifying_Characteristic__c='TestIC'          
        );
        insert opp1;
        
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = con.Id;
        ocr.OpportunityId = opp1.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        
        Proposal__c prpRec = new Proposal__c();
        prpRec.Opportunity__c = opp1.Id;
        prpRec.Name = ''+opp1.Id;
        insert prpRec;
        
      
        
        LIC__c LicRec = new LIC__c(Name='Test Lic',LIC_Request__c='.V1LICNewProposalRequest',Proposal__c = prpRec.Id,
        LIC_Proposal_Tracking__c='Proposal Tracking',LICNewProposalExistingCustomer__c='NewProposalExistingCustomer');
        insert LicRec;
        List<LIC__c> lscLst = new List<LIC__c>();
        lscLst.add(LicRec);
        CanvasPraposalCnt.getOpportunityRecs(opp1,lscLst);
        CanvasPraposalCnt.getOpportunityLst(opp1.Id);
        CanvasPraposalCnt.getProposalRecs(prpRec.Id);
        
       account1.Amdocs_Account_Id__c = '123Test';
       update account1;
       
       CanvasPraposalCnt.getOpportunityLst(opp1.Id);
       //CanvasPraposalCnt.getOpportunityRecs();
    }
    
}