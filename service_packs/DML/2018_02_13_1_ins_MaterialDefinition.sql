
SET QUOTED_IDENTIFIER ON
GO
/*insert [MaterialDefinition] new type of Scrap*/
if not exists (select ID from [dbo].[MaterialDefinition] where ID in (710, 711))
begin
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
	 (710, N'Обрезь негабаритная (без бирки)')
	,(711, N'Обрезь негабаритная (с биркой)')
	) as T1 ([ID],[Description])
	on 1=1
	where MD.[Description] = N'оборотный лом  '
end
	
GO

SET QUOTED_IDENTIFIER OFF
GO