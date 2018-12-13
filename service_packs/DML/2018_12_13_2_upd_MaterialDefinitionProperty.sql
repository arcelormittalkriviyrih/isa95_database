SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- change Scrap property "Вид лома" to "SAP_CODE"
update MDP
set  [Description] = T.[Value]
	,[ClassPropertyID] = T.[ID]
from [dbo].[MaterialDefinitionProperty] MDP
join [dbo].[MaterialClassProperty] MCP
on MCP.[ID] = MDP.[ClassPropertyID]
cross join (
	select top 1
		 MCP1.[ID]
		,MCP1.[Value]
	from [dbo].[MaterialClassProperty] MCP1
	join [dbo].[MaterialClass] MC
	on MC.[ID] = MCP1.[MaterialClassID] and MC.[Description] = N'Лом' and MCP1.[Value] = N'SAP_CODE'
) T
where MCP.[Description] = N'Вид лома'

GO