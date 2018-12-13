
IF OBJECT_ID ('dbo.v_WGT_Materials',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_Materials];
GO

/*
   View: v_WGT_Materials
   Возвращает виды материалов
*/
CREATE VIEW [dbo].[v_WGT_Materials]
AS

select
	 MD.[ID]
	,MD.[Description]
	,MD.[ID]			as [ParentID]
	,MD.[Description]	as [ParentDescription]
	,MDP.[Value]		as [SAPCode]
	,MC.[ID]			as [ClassID]
	,MC.[Description]	as [ClassDescription]
	,MC.[Code]			as [ClassCode]
from [dbo].[MaterialDefinition] MD
join [dbo].[MaterialClass] MC
on MD.[MaterialClassID] = MC.[ID]
left join [dbo].[MaterialDefinition] MD1
on MD.[MaterialDefinitionID] = MD1.[ID]
outer apply(
	select top 1
		 [MaterialDefinitionID]
		,[Description]
		,[Value]
		,[ClassPropertyID]
	from [dbo].[MaterialDefinitionProperty]
	where [Description] = N'SAP_CODE' and [MaterialDefinitionID] = MD.[ID]
	order by [ID] desc
) as MDP
where MC.[Code] in (N'Scrap', N'Finished Products', N'Raw Material')

GO