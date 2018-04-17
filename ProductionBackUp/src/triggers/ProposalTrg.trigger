/**
*  Description: Proposal Trigger . 
*
*   Modification Log : 
---------------------------------------------------------------------------
    Developer               Date                Description
---------------------------------------------------------------------------
    Pradeep               06/27/2017          Created
******************************************************************************************/
trigger ProposalTrg on Proposal__c (after insert,after update) 
{ 
   
  ProposalTriggerHandler proposalTrg = new ProposalTriggerHandler();
    if(Trigger.isUpdate && Trigger.isAfter)
         proposalTrg.afterUpdate(Trigger.new);
         
 }