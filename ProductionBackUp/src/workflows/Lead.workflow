<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clear_Date_of_Status_Change_Field</fullName>
        <field>Date_of_Status_Change__c</field>
        <name>Clear Date of Status Change Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reassign_Lead_to_Removal_Queuee</fullName>
        <field>OwnerId</field>
        <lookupValue>Lead_Removal_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Reassign Lead to Removal Queuee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Source_to_Rep_Entered</fullName>
        <description>Sets the lead source field to a value of &quot;SFDC - Rep Entered&quot;</description>
        <field>LeadSource</field>
        <literalValue>SFDC - Rep Entered</literalValue>
        <name>Set Lead Source to Rep Entered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Status_to_Working</fullName>
        <description>Sets the lead status to Working.</description>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Set Lead Status to Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_to_Removal_Queue</fullName>
        <description>Sets the lead owner to the Removal Queue after 12 days without a status change in the Working or Nurturing status.</description>
        <field>OwnerId</field>
        <lookupValue>Lead_Removal_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Owner to Removal Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_of_Status_Change_Field</fullName>
        <field>Date_of_Status_Change__c</field>
        <formula>TODAY()</formula>
        <name>Update Date of Status Change Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Clear Date of Status Change Field</fullName>
        <actions>
            <name>Clear_Date_of_Status_Change_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Status ), OR( ISPICKVAL(Status , &quot;Unassigned&quot;) ,ISPICKVAL(Status, &quot;Available&quot;), ISPICKVAL(Status , &quot;Converted&quot;), ISPICKVAL(Status , &quot;Not Converted&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Aging Lead</fullName>
        <active>true</active>
        <formula>AND(OR( ISPICKVAL(Status , &quot;Working&quot;),ISPICKVAL(Status , &quot;Nurturing&quot;)), Date_of_Status_Change__c &lt;=  TODAY() - 6)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Aging_Lead_Nofication</name>
                <type>Task</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Lead to Working Upon Assignment to Rep</fullName>
        <actions>
            <name>Set_Lead_Status_to_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the lead status to working when a lead is assigned to a user who is identified as a sales rep on their user record.</description>
        <formula>AND( ISCHANGED( OwnerId ),  Owner:User.Sales_Rep__c = TRUE,OR(ISPICKVAL(Status, &quot;Unassigned&quot;),ISPICKVAL(Status, &quot;Available&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Date of Status Change Field</fullName>
        <actions>
            <name>Update_Date_of_Status_Change_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Status ), OR( ISPICKVAL(Status , &quot;Working&quot;) ,ISPICKVAL(Status, &quot;Nurturing&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Aging_Lead_Nofication</fullName>
        <assignedToType>owner</assignedToType>
        <description>There has been no activity for 6 days, please update this lead.</description>
        <dueDateOffset>6</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Aging Lead Nofication</subject>
    </tasks>
</Workflow>
