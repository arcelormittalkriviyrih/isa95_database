
/*insert [MaterialDefinitionProperty] types of Scrap*/
insert into [dbo].[MaterialDefinitionProperty]
	([Description]
	,[Value]
	,[MaterialTestSpecificationID]
	,[MaterialDefinitionID]
	,[ClassPropertyID]
	,[PropertyType]
	,[UnitID]
	,[MaterialDefinitionProperty])
select 
	 MCP.[Description]		as [Description]
	,MD1.[ID]				as [Value]
	,null					as [MaterialTestSpecificationID]
	,MD1.[ID]				as [MaterialDefinitionID]
	,MCP.[ID]				as [ClassPropertyID]
	,null					as [PropertyType]
	,null					as [UnitID]
	,null					as [MaterialDefinitionProperty]
from [dbo].[MaterialDefinition] MD
join [dbo].[MaterialClass] MC
on MD.[MaterialClassID] = MC.[ID]
join [dbo].[MaterialDefinition] MD1
on MD1.MaterialDefinitionID = MD.[ID]
join [dbo].[MaterialClassProperty] MCP
on MCP.[MaterialClassID] = MD1.[MaterialClassID]
where  MC.[Description] = N'Лом' and MD.[MaterialDefinitionID] is null and MCP.[Description] = N'Вид лома'
	
GO
