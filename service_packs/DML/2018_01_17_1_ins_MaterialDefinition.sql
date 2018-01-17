
SET QUOTED_IDENTIFIER ON
GO
/*insert [MaterialDefinition] new type of Scrap*/
insert into [dbo].[MaterialDefinition](
	 [ID]
	,[Description]
	,[Location]
	,[HierarchyScope]
	,[MaterialClassID]
	,[MaterialDefinitionID])
select
	 T1.[ID]
	,T1.[Description]
	,null
	,1
	,MD.[MaterialClassID]
	,MD.[ID]
from [dbo].[MaterialDefinition] MD
inner join 
(values
(830, N'Смесь шихтовая №4, Керамет')
) as T1 ([ID],[Description])
on 1=1
where MD.[Description] = N'смешанный лом  '

GO

SET QUOTED_IDENTIFIER OFF
GO