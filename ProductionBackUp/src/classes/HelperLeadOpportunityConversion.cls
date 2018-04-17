/****************************************************************************
*Name           : LeadTriggerHandler 
*Description    : On conversion of a lead to Opportunity, due to the order of execution problem, 
*                 the workflow rule  updating the Opportunity name(Left("Account Name", 20)+Left("Identifying Characterstics", 10)+Date)
*                 does not have the Identifying Charecterstics value at the time the Opportunity record is created because Identifying 
*                 Charecterstics is updated to be first 10 chars of Opportunity's Product of Interest by another workflow rule. So an after
*                  update trigger is written on Leads that are converted to update the Opportunity's Product of Interest on creation of opportunity, 
*                  hence making it available for the "OpportunityNameUpdate" Workflow rule to have the Identifying Charecterstics value available.
*                  On updation of opportunity, the values are still updated by the Workflow rule "Identifying Characteristic Update".
*
******************************************************************************
* Version       Date          Author                Description
* ----------------------------------------------------------------------------
* 1.0           03/28/2017    Nidhi Shekar          Created.
* 2.0           08/03/2017    Kumar Manegalla       Created.
******************************************************************************/
public without sharing class HelperLeadOpportunityConversion {
    /*
        Descriptuion : update Opportunity On Creation
    */
    public void afterUpdate(List<Lead> leadsConverted )
    {
        try
        {
            /***Map of the converted Opportunity ID and the corresponding Lead's Product of Interest value***/
            Map<Id,String> convertedOppMap = new Map<Id,String>();
            /***For Every Lead that is converted, Opportunity Id and the POI value of the lead are added to a map***/
            for(Lead lead : leadsConverted) 
            {
                if ((lead.IsConverted)&&(lead.Product_of_Interest__c != null))
                {
                    System.debug('Inside Converted');
                    convertedOppMap.put(lead.ConvertedOpportunityId,lead.Product_of_Interest__c);
                    System.debug('convertedOppMap:'+convertedOppMap);
                }
                if ((lead.IsConverted)&&(lead.Product_of_Interest__c == null))
                {
                    System.debug('Inside Converted');
                    convertedOppMap.put(lead.ConvertedOpportunityId,'');
                    System.debug('convertedOppMap:'+convertedOppMap);
                }
            }
            
            /***For Every Opportunity that was just created, the Product of Interest value is copied over from the Lead object's Product of Interest***/
            
            List<Opportunity> oppFromConversion = [select Id, Product_of_Interest__c from Opportunity WHERE Opportunity.Id IN :convertedOppMap.keySet()];
            System.debug('Opp from Converted'+oppFromConversion);
            for ( Opportunity opp : oppFromConversion) 
            {
                if(opp.Product_of_Interest__c!=null)
                    opp.Product_of_Interest__c = convertedOppMap.get(opp.Id);
                else
                     opp.Product_of_Interest__c=null;
                
                
                System.debug('opp:'+opp);
            }
            System.debug('oppFromConversion:'+oppFromConversion);
            if(!oppFromConversion.isEmpty())
                update oppFromConversion;
        }catch(Exception e) 
        {           
           
            
        }
    }
    /**
    * Description: 
    *
    * @param    NewLeadRecords - New List of Lead records 
    */
    public void afterInsert(List<Lead> newLeadRecords)
    {
        Map<string,Lead> leadMap = new Map<string,Lead>();
        for(Lead leadIterate : newLeadRecords)
        {
            if(null != leadIterate.Customer_ID__c)
                leadMap.put(leadIterate.Customer_ID__c,leadIterate);        
        }
        
        Map<string,Id> accOwnerMap = new Map<string,Id>(); //Map of Amdocs_Account_ID__c as key and OwnerId as value.
        System.debug('leadMap*******************: ' + leadMap);
        if(!leadMap.isEmpty())
        {
            List<Account> accLst = [select Id,name,Owner.Email,Amdocs_Account_ID__c,OwnerId from Account where Amdocs_Account_ID__c IN: leadMap.keyset()];
            System.debug('accLst*******************: ' + accLst);
            if(!accLst.isEmpty())
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.subject = 'Lead Assigned';
                
                for(Account accIterate : accLst)
                {
                    System.debug('accIterate*******************: ' + accIterate);
                    if(null != accIterate.Amdocs_Account_ID__c)
                        accOwnerMap.put(accIterate.Amdocs_Account_ID__c,accIterate.OwnerId);    
                    
                    message.toAddresses = new String[] {accIterate.Owner.Email};
                    message.plainTextBody = 'A New Lead has been assigned to you.';
                }
                message.optOutPolicy = 'FILTER';
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }
                
                
            }
        }
        System.debug('accOwnerMap*******************: ' + accOwnerMap);
        if(!accOwnerMap.isEmpty())
        {
            Map<Id,string> updateLedOwnerMap = new Map<Id,string>();
            for(Lead leadIterate : newLeadRecords)
            {
                if(accOwnerMap.containsKey(leadIterate.Customer_ID__c))
                {
                   // leadIterate.OwnerId = accOwnerMap.get(leadIterate.Customer_ID__c);
                    updateLedOwnerMap.put(leadIterate.Id,accOwnerMap.get(leadIterate.Customer_ID__c));
                }
                System.debug('leadIterate.OwnerId***************'+leadIterate.OwnerId);
            }
            System.debug('updateLedOwnerMap*************'+updateLedOwnerMap);
            if(!updateLedOwnerMap.isEmpty())
                updateLedOwner(updateLedOwnerMap);
        }
    }
    
    @future
    public static void updateLedOwner(Map<Id,string> LedRecords){
        if(!LedRecords.isEmpty())
        {
            List<Lead> ledUpdate = new List<Lead>();
            for(Id ledId : LedRecords.keyset()){
                Lead ledRec = new Lead(id=ledId);
                ledRec.OwnerId = LedRecords.get(ledId);
                ledUpdate.add(ledRec);
            }
            if(!ledUpdate.isEmpty())
                update ledUpdate;
            
        }
        
    }
}