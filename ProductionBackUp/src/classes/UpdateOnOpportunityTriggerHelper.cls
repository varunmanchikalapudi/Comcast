public with sharing class UpdateOnOpportunityTriggerHelper 
{   
     
     public static void UpdatefieldsOnOpportunity(List<Opportunity> opportunities)
     {
          for(Opportunity opp: opportunities)
        {
            
            String Ic = '';
            String AccountName=opp.Account_Name_Text__c;
            system.debug('AccountName:  '+AccountName);

            /*Account Name is formulated */
            If(AccountName.length()>17)
            AccountName=AccountName.left(17)+'...';
            system.debug('AccountName:  '+AccountName);


            /*Over IC and POI, IC gets precedence. So if both exist, IC over writes POI. Else left 10 Chars of POI are copied over */
            if(opp.Product_Of_Interest__c!=null) 
                Ic=opp.Product_Of_Interest__c.replaceAll(';','+').left(10);
                
            If(opp.Identifying_Characteristic__c!=null)
                Ic=opp.Identifying_Characteristic__c.left(10); 
                
          //  if((opp.Product_Of_Interest__c==null)&&(opp.Identifying_Characteristic__c==null))
          //      Ic=' ';
            
            system.debug('Ic:  '+Ic);
            
            /*Create Date is set to now*/ 
            Date createDate=Date.today();
            system.debug('createDate:  '+createDate);

            if(Ic!=' ')
                opp.Name=AccountName+'-'+Ic+'-'+createDate.format();

            system.debug('opp.Name:  '+opp.Name);
        }
     }

    public static void chatterpost(List<Opportunity> opportunities)
    {                                                                                             
        Map<Id,Opportunity> accIdMap = new Map<Id,Opportunity>();
            for(Opportunity oppIterate : opportunities)
         // for(Opportunity oppIterate : Trigger.New)
                {
                  accIdMap.put(oppIterate.AccountId,oppIterate);
                }   
        
        if(!accIdMap.isEmpty())
        {
            List<AccountTeamMember> accTemLst = [select Id,TeamMemberRole,UserId,AccountId,Account.Name from AccountTeamMember where AccountId IN: accIdMap.keyset() AND TeamMemberRole =: 'Account Manager']; 
            
            for(AccountTeamMember accTemIterate : accTemLst)/***********Invoking chatter API to post feed Element***********/
                {
                  ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), accTemIterate.UserId, ConnectApi.FeedElementType.FeedItem, 'A New Opportunity is Created with name '+ accIdMap.get(accTemIterate.AccountId).Name +' of account '+ accTemIterate.Account.Name+ ' '+URL.getSalesforceBaseUrl().toExternalForm() + '/' + accTemIterate.AccountId);
                }
            
        
        }
    }
}