<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Concatenate_POI</fullName>
        <description>If multiple products of interest are selected a “+” will be used to concatenate the values.</description>
        <field>Identifying_Characteristic__c</field>
        <formula>LEFT(IF(INCLUDES( Product_Of_Interest__c , &quot;Eth&quot;), &quot;Eth+&quot;, NULL)  + 
IF(INCLUDES( Product_Of_Interest__c , &quot;PRI&quot;), &quot;PRI+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;SIP&quot;), &quot;SIP+&quot;, NULL)  + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BVE&quot;), &quot;BVE+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BI&quot;), &quot;BI+&quot;, NULL)  + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BTVPub&quot;), &quot;BTVPub+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BTVPri&quot;), &quot;BTVPri+&quot;, NULL)  +
IF(INCLUDES( Product_Of_Interest__c , &quot;BV&quot;), &quot;BV+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;SAAS&quot;), &quot;SAAS+&quot;, NULL),
10)</formula>
        <name>Concatenate POI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DefualtOpportunityNameUpdate</fullName>
        <field>Name</field>
        <formula>IF( LEN(Account.Name)&gt;17 , LEFT(Account.Name, 17)  &amp; &apos;...&apos;,LEFT(Account.Name, 17)  )&amp;  LEFT(IF(INCLUDES( Product_Of_Interest__c , &quot;Eth&quot;), &quot;Eth+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;PRI&quot;), &quot;PRI+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;SIP&quot;), &quot;SIP+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BVE&quot;), &quot;BVE+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BI&quot;), &quot;BI+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BTVPub&quot;), &quot;BTVPub+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BTVPri&quot;), &quot;BTVPri+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;BV&quot;), &quot;BV+&quot;, NULL) + 
IF(INCLUDES( Product_Of_Interest__c , &quot;SAAS&quot;), &quot;SAAS+&quot;, NULL), 
10)&amp; &apos;-&apos; &amp;    TEXT(DATEVALUE(CreatedDate ))</formula>
        <name>Defualt Opportunity Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>OpportunityNameUpdate</fullName>
        <actions>
            <name>DefualtOpportunityNameUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Default Opportunity Name must be in the format of &quot;Account Name&quot; - &quot;Identifying Characteristic+ Short Date&quot;</description>
        <formula>ISNULL( Product_Of_Interest__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
