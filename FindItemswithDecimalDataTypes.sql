WITH XMLNAMESPACES (Default 'urn:ihe:qrph:sdc:2016')
SELECT
-- generic info from the relational table
templatexmlfileid
,[ChecklistVersionVisibleText]
,[WebPostingDate]
-- Generic info from the protocol properties
,[TemplateXML].value('(/FormDesign/Property[@name="CAP_ProtocolShortName"]/./@val)[1]','nvarchar(max)') as ProtocolName
,[TemplateXML].value('(/FormDesign/Property[@name="TemplateID"]/./@val)[1]','nvarchar(max)') as ID
,[TemplateXML].value('(/FormDesign/Property[@name="CAP_ProtocolVersion"]/./@val)[1]','nvarchar(max)') as Version

-- data from the XML doc
,x.q.value('../../../@title', 'nvarchar(max)') as QuestionTitle
,x.q.value('../../../@ID', 'nvarchar(300)') as CKey
,x.q.value('../../../@order', 'nvarchar(300)') as [Order]
FROM [dbo].[TemplateVersionXML] t
cross apply t.[TemplateXML].nodes('(/FormDesign//Response/decimal)') x(q)
where [TemplateXML].exist('(/FormDesign//Response/decimal)') =1
