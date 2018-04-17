<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mark_Opportunity_Closed</fullName>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>Mark Opportunity Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Signed Proposal</fullName>
        <actions>
            <name>Mark_Opportunity_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proposal__c.Status__c</field>
            <operation>equals</operation>
            <value>Signed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
