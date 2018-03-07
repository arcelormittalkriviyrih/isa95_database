
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
		 T.[ID]
		,T.[Description]
		,null
		,1
		,MD.[MaterialClassID]
		,MD.[ID]
from [dbo].[MaterialDefinition] MD
inner join 
(values
	 (181, N'Обрезь габаритная (вид 2)', N'оборотный лом')
	,(310, N'Брак заготовок (вид 500)', N'оборотный лом')
	,(312, N'Брак стальной негабаритный (вид 500)', N'оборотный лом')
	,(777, N'Лом стальной негабаритный (вид 500)', N'смешанный лом')
) as T([ID],[Description], [ParentDescription])
on MD.[Description] = T.[ParentDescription]
left join [dbo].[MaterialDefinition] MD1
on T.[ID] = MD1.[ID]
where MD1.[ID] is null
	
GO

SET QUOTED_IDENTIFIER OFF
GO