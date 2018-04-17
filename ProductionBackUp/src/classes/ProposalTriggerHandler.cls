/**
*  Description: Proposal Trigger . 
*
*   Modification Log : 
---------------------------------------------------------------------------
    Developer               Date                Description
---------------------------------------------------------------------------
    KUMAR               06/27/2017          Created
******************************************************************************************/
public without sharing class ProposalTriggerHandler
{
    /**
    * Description:
    *
    */
    public void afterUpdate(List<Proposal__c> Proposals)
    {
        try
        {             
            //set<String> oppIdset = new set<String>();
            
            Map<Id,string> oppMap = new Map<Id,string>();
            
            for(Proposal__c propIterate : Proposals)
            {
                if((propIterate.Status__c == 'Signed' || propIterate.Status__c == 'Sent to customer') && propIterate.Opportunity__c != null)
                {
                    //oppIdset.add(propIterate.Opportunity__c);
                    oppMap.put(propIterate.Opportunity__c,propIterate.Status__c);
                }
            }

            List<Opportunity> opportunityList = [SELECT id,Probability,StageName FROM Opportunity WHERE id IN: oppMap.keyset()];
            
            List<Opportunity> opportunityUpdate = new List<Opportunity>();
            for(Opportunity oppIterate : opportunityList )
            {
                if(oppMap.containsKey(oppIterate.Id))
                {
                    if(oppMap.get(oppIterate.Id) == 'Signed')
                    {
                        oppIterate.StageName= 'Closed Won';
                        oppIterate.Probability = 100;
                    }
                    else if(oppMap.get(oppIterate.Id) == 'Sent to customer')
                    {
                        oppIterate.StageName= 'Negotiation';
                        oppIterate.Probability= 90;
                    }
                    opportunityUpdate.add(oppIterate);
                }
            }
            
            if(!opportunityUpdate.isEmpty())
                update opportunityUpdate ;  
            
            system.debug('Optys - '+opportunityUpdate); 
        }catch(Exception e)
        {
        
        }

    }
}