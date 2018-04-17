/****************************************************************************************************************************************************************
* Trigger Name: UpdateFieldsOnOpportunityTrigger
* Author: Nidhi Shekar
* Date: 12-Apr-2017 
* Modified Date : 5/11/2017 by Kumar
* Requirement/Project Name: Orion SFDC Implementation
* Requirement/Project Description: On creation and updation of an opportunity including the opportunity created due to conversion, this trigger is fired. It is 
only not fired in one scenario where the POI is null. This is because if opportunity is created by a trigger with blank values for IC and POI, it fails on Validation rule. 
The only way to by pass when the poi is null and it is converted from lead is use a Workflow rule.
* Requirement Description :A chatter notification should be sent to the member of an account team with a role of "Account Manager"  when a different user creates an opportunity off of the account.
*****************************************************************************************************************************************************************/
trigger UpdateFieldsOnOpportunityTrigger on Opportunity (before update, before insert,after Insert) 
{
     
    if(Trigger.isBefore)
    
    {
    
   
    UpdateOnOpportunityTriggerHelper.UpdatefieldsOnOpportunity(Trigger.new);
      /*  for(Opportunity opp: Trigger.New)
        {
            
            String Ic;
            String AccountName=opp.Account_Name_Text__c;
            system.debug('AccountName:  '+AccountName);

            /*Account Name is formulated */
           /* If(AccountName.length()>17)
            AccountName=AccountName.left(17)+'...';
            system.debug('AccountName:  '+AccountName);


            /*Over IC and POI, IC gets precedence. So if both exist, IC over writes POI. Else left 10 Chars of POI are copied over */
          /*  if(opp.Product_Of_Interest__c!=null) 
                Ic=opp.Product_Of_Interest__c.replaceAll(';','+').left(10);
                
            If(opp.Identifying_Characteristic__c!=null)
                Ic=opp.Identifying_Characteristic__c.left(10); 
                
            if((opp.Product_Of_Interest__c==null)&&(opp.Identifying_Characteristic__c==null))
                Ic=' ';
            
            system.debug('Ic:  '+Ic);
            
            /*Create Date is set to now*/ 
            Date createDate=Date.today();
            system.debug('createDate:  '+createDate);

          /*  if(Ic!=' ')
                opp.Name=AccountName+'-'+Ic+'-'+createDate.format();

            system.debug('opp.Name:  '+opp.Name);
        } */
    
    /***********Updated by Kumar-Code starts**********/
    
    }else if(Trigger.isAfter && Trigger.isinsert){
    
    
    UpdateOnOpportunityTriggerHelper.chatterpost(Trigger.new);
    
      /**  Map<Id,Opportunity> accIdMap = new Map<Id,Opportunity>();
        for(Opportunity oppIterate : Trigger.New)
        {
            accIdMap.put(oppIterate.AccountId,oppIterate);
        }   
        
        if(!accIdMap.isEmpty())
        {
            List<AccountTeamMember> accTemLst = [select Id,TeamMemberRole,UserId,AccountId,Account.Name from AccountTeamMember where AccountId IN: accIdMap.keyset() AND TeamMemberRole =: 'Account Manager']; 
            
            for(AccountTeamMember accTemIterate : accTemLst) 
           {
              ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), accTemIterate.UserId, ConnectApi.FeedElementType.FeedItem, 'A New Opportunity is Created with name '+ accIdMap.get(accTemIterate.AccountId).Name +' of account '+ accTemIterate.Account.Name+ ' '+URL.getSalesforceBaseUrl().toExternalForm() + '/' + accTemIterate.AccountId);
            }
            
        
        } **/
    /***********Updated by Kumar-Code Ends***********/
    }
        
    }