
/*insert [MaterialDefinition] new type of Finished Products*/
insert into [dbo].[MaterialDefinition](
	 [Description]
	,[Location]
	,[HierarchyScope]
	,[MaterialClassID]
	,[MaterialDefinitionID])
select
	 T.[Description]
	,null		as [Location]
	,1			as [HierarchyScope]
	,MC.[ID]	as [MaterialClassID]
	,null		as [MaterialDefinitionID]
from (values (N'Готовая продукция', N'Готовая продукция')) as T([Description], [ParentDescription])
join [dbo].[MaterialClass] MC
on T.[ParentDescription] = MC.[Description]
left join [dbo].[MaterialDefinition] MD
on T.[Description] = MD.[Description]
where MD.[ID] is null

GO