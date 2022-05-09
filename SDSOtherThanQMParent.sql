WITH XMLNAMESPACES (Default 'urn:ihe:qrph:sdc:2016')
select * from (
SELECT
-- generic info from the relational table
templatexmlfileid
,[ChecklistVersionVisibleText]
,[WebPostingDate]
-- Generic info from the protocol properties
,y.g.value('.','nvarchar(max)') as ProtocolName
,ti.g.value('.','nvarchar(max)') as ID
,pv.g.value('.','nvarchar(max)') as Version

-- data from the XML doc
,x.q.value('../@title', 'nvarchar(max)') as Title
,x.q.value('../@ID', 'nvarchar(300)') as CKey
,x.q.value('local-name(../..)', 'nvarchar(300)') as ItemType
,x.q.value('local-name(../../..)', 'nvarchar(300)') as ParentItemType
,x.q.value('../../../@maxSelections[1]', 'nvarchar(300)') as maxSelections
FROM [dbo].[TemplateVersionXML]
cross apply [TemplateXML].nodes('(/FormDesign//@selectionDeselectsSiblings[.="true"])') x(q)
outer apply [TemplateXML].nodes('(/FormDesign/Property/@val[../@name="CAP_ProtocolShortName"])[1]') y(g)
outer apply [TemplateXML].nodes('(/FormDesign/Property/@val[../@name="TemplateID"])[1]') ti(g)
outer apply [TemplateXML].nodes('(/FormDesign/Property/@val[../@name="CAP_ProtocolVersion"])[1]') pv(g)
) as a
where a.maxSelections=1 or a.maxSelections is null
