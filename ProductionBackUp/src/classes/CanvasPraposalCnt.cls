/****************************************************************************
*Name           :    CanvasPraposalCnt
*Description    :    This class is used to send json parameters inside canvas.
*
******************************************************************************
Version     Date            Author                      Description
----------------------------------------------------------------------------

1.0         07/21/2017      Pradeepkumar Manegalla      Created.  

******************************************************************************/ 

public class CanvasPraposalCnt {
    @AuraEnabled 
    public static string getProposalRecs(Id recordId) {
        String SessId = Userinfo.getSessionID();
        system.debug('**RecId***'+recordId); 
        string JSONString;
        List<LIC__c> licLst = [select Id,Name,LIC_Request__c,LIC_Proposal_Tracking__c,Proposal__c from LIC__c where  LIC_Proposal_Tracking__c=: '.V1LICProposalTrackingRequest' limit 1];   
        // system.debug('**licLst ***'+licLst );
        Proposal__c proposalRec = new Proposal__c();
        if(!licLst.isEmpty())
        {
            for(LIC__c licIterate : licLst)
            {
                JSONString  = '{"requestType": "' + licIterate.LIC_Proposal_Tracking__c+ '",';
            }
            
        }
        
        if(string.isNotBlank(recordId)){
            
            proposalRec = [select Id,Name,Opportunity__c,Opportunity__r.Name,Amdocs_Proposal_Id__c,
                           Opportunity__r.Account.Amdocs_Account_ID__c,
                           Opportunity__r.Account.Amdocs_Parent_Account_ID__c,
                           Opportunity__r.Account.Id,Opportunity__r.Account.Name,Opportunity__r.Account.Type,
                           Opportunity__r.Account.Customer_Sub_Type__c,Opportunity__r.Account.Industry,
                           Opportunity__r.Account.Sub_Industry__c,Opportunity__r.Account.Special_Population__c,
                           Opportunity__r.Account.BillingStreet,Opportunity__r.Account.BillingCity,
                           Opportunity__r.Account.BillingState,Opportunity__r.Account.BillingCountry,
                           Opportunity__r.Account.BillingPostalCode from Proposal__c where Id =: recordId];
            
            
            List<Contact> contacts=[SELECT id, firstName, lastName, middleName, mobilePhone, email FROM Contact 
                                    where Id in (select ContactId from opportunitycontactrole where opportunityid=:proposalRec.Opportunity__c)];
            
            String associatedContacts = null;
            If(!contacts.isEmpty())
            {
                associatedContacts=JSON.serialize(contacts);    
            JSONString += '"contacts": "' + associatedContacts + '",'; 
            }
            Else
            {
              associatedContacts=JSON.serialize(contacts);    
            JSONString += '"contacts": ' + associatedContacts + ',';
            }
                    
                   // JSONString += '"contacts": "' + associatedContacts + '",';
                    JSONString += '"userId": "' + userInfo.getUserId() + '",';
                    JSONString += '"opportunityId": "' + proposalRec.Opportunity__c+ '",';
                    JSONString += '"customerExternalIdType": "SFDC",';
                    JSONString += '"clientAppId": "SFDC_ORION",';
                    JSONString += '"customerId": "' + proposalRec.Opportunity__r.Account.Amdocs_Account_ID__c + '",';                    
                    JSONString += '"proposalId": "' + proposalRec.Amdocs_Proposal_Id__c + '",';
                    JSONString += '"opportunityName": "' + proposalRec.Opportunity__r.Name + '",';
                    
                    User cliUser = [SELECT Id,FirstName,LastName,FederationIdentifier,Amdocs_Roles__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                    
                    String userFederationIdentifier = cliUser.FederationIdentifier;
                    String amdocsRoles = cliUser.Amdocs_Roles__c;
                    String subFirstName = cliUser.FirstName;
                    String subLastName = cliUser.LastName;
                    
                    JSONString += '"createdAt": "' + Datetime.now().format('MM/dd/yyyy HH:mm')+ '",';
                    JSONString += '"sessionId": "' + SessId + '",'; 
                    JSONString += '"iss": "SFDC_CANVAS",';
                    JsonString +=' "sub":"'  + userFederationIdentifier + '",';
                    JsonString +=' "amdocsRoles":["'  + amdocsRoles + '"],';
                    JsonString +=' "subLastName":"'  + subLastName + '",';
                    JSONString += '"subFirstName": "' + subFirstName + '"}';  
            
            if(string.isNotBlank(JSONString))
            {
                JSONString = JSONString.replace('"[{', '[{');
                JSONString = JSONString.replace('}]"', '}]');
            }
            
            
            system.debug('**JSONString***'+JSONString); 
            //  return JSONString ;
        }
        system.debug('**JSONString***'+JSONString); 
        
        return JSONString ;
        
    }
    
    
    
    @AuraEnabled 
    public static string getOpportunityLst(Id recordId) {
        
        system.debug('**RecId***'+recordId);
        string JSONString;
        if(string.isNotBlank(recordId)){
            Opportunity OppRec = [select Id,Name,Account.Amdocs_Account_ID__c,Account.Amdocs_Parent_Account_ID__c,Account.Id,Account.Name,Account.Type,Account.Customer_Sub_Type__c,Account.Industry,Account.Sub_Industry__c,Account.Special_Population__c,Account.BillingStreet,Account.BillingCity,Account.BillingStateCode,Account.BillingCountryCode,Account.BillingPostalCode from Opportunity where Id=: recordId];
            
            List<LIC__c> licLst = [select Id,Name,LIC_Request__c,LIC_Proposal_Tracking__c,LICNewProposalExistingCustomer__c,Proposal__c from LIC__c ];   
            system.debug('**licLst ***'+licLst );    
            system.debug('***OppRec.Account.Amdocs_Account_ID__c***'+OppRec.Account.Amdocs_Account_ID__c);   
            if(null != OppRec)
            {
                if(null != OppRec.Account.Amdocs_Account_ID__c)
                    JSONString = updateOpportunityRecs(OppRec,licLst);
                
                else
                    JSONString =getOpportunityRecs(OppRec,licLst);
                // JSONString = getOpportunityRecs(OppRec,licLst);   
                
                //return JSONString;
            }
        }
        return JSONString;   
    } 
    
    @AuraEnabled
    public static string getOpportunityRecs(Opportunity OppRec,List<LIC__c> licLst) {
        
        
        system.debug('**OppRec123***'+OppRec); 
        String SessId = Userinfo.getSessionID();
        string JSONString;
        if(null != OppRec)  
        {
            // JSONString  = '{"opportunityID111": "' + OppRec.Id + '",';
            if(!licLst.isEMpty())
            {
                for(LIC__c licIterate : licLst)
                {
                    if(licIterate.LIC_Request__c == '.V1LICNewProposalRequest')
                        //JSONString  += '"requestType": "' + licIterate.   LIC_Request__c+ '",';
                        JSONString  = '{"requestType": "' +licIterate.LIC_Request__c+ '",';
                    
                }
            }
          
            
            JSONString += '"opportunityId": "' + OppRec.Id + '",';
            JSONString += '"iss": "SFDC_CANVAS",';
            JSONString += '"createdAt": "' + Datetime.now().format('MM/dd/yyyy HH:mm')+ '",';
            JSONString += '"sessionId": "' + SessId + '",';   
            JSONString += '"clientAppId": "SFDC_ORION",';
            JSONString += '"opportunityName": "' + OppRec.Name + '",';
            
         //  JSONString += '"customerId": "' + OppRec.Account.Amdocs_Account_ID__c + '",';
            
            If(null != OppRec.Account.Amdocs_Account_ID__c)
           {
                   
            JSONString += '"customerId": "' + OppRec.Account.Amdocs_Account_ID__c + '",'; 
            }
          Else
          {
                 
          JSONString += '"customerId": ' + OppRec.Account.Amdocs_Account_ID__c + ',';
            }
            
            JSONString += '"customerParentId ": "' + OppRec.Account.Amdocs_Parent_Account_ID__c + '",';
            JSONString += '"customerExternalIdType": "SFDC",';
            JSONString += '"customerExternalIdValue": "' + OppRec.Account.Id + '",';
            JSONString += '"customerName": "' + OppRec.Account.Name + '",';
            JSONString += '"customerTypeId": "' + OppRec.Account.Type + '",';
            JSONString += '"customerSubtypeId": "' + OppRec.Account.Customer_Sub_Type__c + '",';
            JSONString += '"customerIndustry": "' + OppRec.Account.Industry + '",';
            //JSONString += '"customerSubIndustry": "' + OppRec.Account.Sub_Industry__c + '",';
            JSONString += '"customerSpecialPopulation": "' + OppRec.Account.Special_Population__c + '",';
            JSONString += '"customerPostalStreet1": "' + OppRec.Account.BillingStreet + '",';
            JSONString += '"customerPostalCity": "' + OppRec.Account.BillingCity + '",';
            JSONString += '"customerPostalStateOrProvince": "' + OppRec.Account.BillingStateCode + '",';
            JSONString += '"customerPostalCountry": "' + OppRec.Account.BillingCountryCode + '",';
            JSONString += '"customerPostalPostcode": "' + OppRec.Account.BillingPostalCode + '",';
            
            List<Contact> contacts=[SELECT id, firstName, lastName, middleName, mobilePhone, email FROM Contact 
                                    where Id in (select ContactId from opportunitycontactrole where opportunityid=:OppRec.Id and IsPrimary =: true )];
            
           String associatedContacts = null;
            If(!contacts.isEmpty())
            {
                associatedContacts=JSON.serialize(contacts);    
            JSONString += '"contacts": "' + associatedContacts + '",'; 
            }
            Else
            {
              //associatedContacts=JSON.serialize(contacts);    
            JSONString += '"contacts": ' + associatedContacts + ',';
            }
            JSONString += '"userId": "' + userInfo.getUserId() + '",';
            
            User cliUser = [SELECT Id,FirstName,LastName,FederationIdentifier,Amdocs_Roles__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            String userFederationIdentifier = cliUser.FederationIdentifier;
            String amdocsRoles = cliUser.Amdocs_Roles__c;
            String subFirstName = cliUser.FirstName;
            String subLastName = cliUser.LastName;
            
           JsonString +=' "sub":"'  + userFederationIdentifier + '",';
           JsonString +=' "amdocsRoles":["'  + amdocsRoles + '"],';
           JsonString +=' "subLastName":"'  + subLastName + '",';
           JSONString += '"subFirstName": "' + subFirstName + '"}';  
            
            
            
            if(string.isNotBlank(JSONString))
            {
                JSONString = JSONString.replace('"[{', '[{');
                JSONString = JSONString.replace('}]"', '}]');
            }
            
            
            system.debug('**JSONString***'+JSONString); 
            return JSONString ;
        }
        
        return JSONString ;
    }
    
    
    @AuraEnabled 
    public static string updateOpportunityRecs(Opportunity OppRec,List<LIC__c> licLst) {
        system.debug('Datetime***** : '+ DateTime.now());
        String SessId = Userinfo.getSessionID();
        system.debug('timestamp****** : '+ DateTime.now().getTime());
        // return String.valueof(DateTime.now().getTime());
        system.debug('**OppRec***'+OppRec); 
        
        string JSONString;
        
        if(null != OppRec){
           
            if(!licLst.isEMpty())
                for(LIC__c licIterate : licLst)
            {
                if(licIterate.LICNewProposalExistingCustomer__c == '.V1LICNewProposalRequest')
                {
                    JSONString  = '{"requestType": "' + licIterate.LICNewProposalExistingCustomer__c+ '",';
                }
               
                  
            }
                
                JSONString += '"iss": "SFDC_CANVAS",';
                JSONString += '"createdAt": "' + Datetime.now().format('MM/dd/YYYY HH:mm')+ '",';
                JSONString += '"sessionId": "' + SessId + '",'; 
                JSONString += '"opportunityId": "' + OppRec.Id + '",';
               
                JSONString += '"clientAppId": "SFDC_ORION",';
                JSONString += '"opportunityName": "' + OppRec.Name + '",';
                JSONString += '"customerId": "' + OppRec.Account.Amdocs_Account_ID__c + '",';
               
                JSONString += '"customerExternalIdType": "SFDC",';
                
            
            List<Contact> contacts=[SELECT id, firstName, lastName, middleName, mobilePhone, email FROM Contact 
                                    where Id in (select ContactId from opportunitycontactrole where opportunityid=:OppRec.Id and IsPrimary =: true )];
            
            String associatedContacts = null;
            If(!contacts.isEmpty())
            {
                associatedContacts=JSON.serialize(contacts);    
            JSONString += '"contacts": "' + associatedContacts + '",'; 
            }
            Else
            {
             // associatedContacts=JSON.serialize(contacts);    
            JSONString += '"contacts": ' + associatedContacts + ',';
            }
            
            JSONString += '"userId": "' + userInfo.getUserId() + '",';
            
            User cliUser = [SELECT Id,FirstName,LastName,FederationIdentifier,Amdocs_Roles__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            String userFederationIdentifier = cliUser.FederationIdentifier;
            String amdocsRoles = cliUser.Amdocs_Roles__c;
            String subFirstName = cliUser.FirstName;
            String subLastName = cliUser.LastName;
            
            JsonString +=' "sub":"'  + userFederationIdentifier + '",';
            JsonString +=' "amdocsRoles":["'  + amdocsRoles + '"],';
            JsonString +=' "subLastName":"'  + subLastName + '",';
            JSONString += '"subFirstName": "' + subFirstName + '"}'; 
            
            
            
            if(string.isNotBlank(JSONString))
            {
                JSONString = JSONString.replace('"[{', '[{');
                JSONString = JSONString.replace('}]"', '}]');
            }
            system.debug('**JSONString***'+JSONString); 
            return JSONString ;
        }
        
        return JSONString ;
    }
}