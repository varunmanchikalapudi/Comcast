/****************************************************************************
*Name           : LeadTrigger
*Description    : On conversion of a lead to Opportunity, due to the order of execution problem, 
*                 the workflow rule  updating the Opportunity name(Left("Account Name", 20)+Left("Identifying Characterstics", 10)+Date)
*                 does not have the Identifying Charecterstics value at the time the Opportunity record is created because Identifying 
*                 Charecterstics is updated to be first 10 chars of Opportunity's Product of Interest by another workflow rule. So an after
*                 update trigger is written on Leads that are converted to update the Opportunity's Product of Interest on creation of opportunity, 
*                 hence making it available for the "OpportunityNameUpdate" Workflow rule to have the Identifying Charecterstics value available.
*                 On updation of opportunity, the values are still updated by the Workflow rule "Identifying Characteristic Update".
*
******************************************************************************
* Version       Date          Author                Description
* ----------------------------------------------------------------------------
* 1.0           03/28/2017    Nidhi Shekar          Created.
* 1.1           07/25/2017    Kumar Manegalla       Updated.
******************************************************************************/ 
trigger MapFieldsOnLeadConversionTrigger on Lead (after insert,after update) 
{ 
   /***Leads after update, call the "HelperLeadOpportunityConversion" class passing the lead records that triggered this process as parameters***/ 
  HelperLeadOpportunityConversion leadTrigger = new HelperLeadOpportunityConversion();
    
    
    if(Trigger.isInsert && Trigger.isAfter)
        leadTrigger.afterInsert(Trigger.new);
    else if(Trigger.isUpdate && Trigger.isAfter)
        leadTrigger.afterUpdate(Trigger.new);
}