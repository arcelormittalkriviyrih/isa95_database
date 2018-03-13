
IF OBJECT_ID ('dbo.v_WGT_ScrapTypes',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_ScrapTypes];
GO

/*
   View: v_WGT_ScrapTypes
   Возвращает виды лома
*/
CREATE VIEW [dbo].[v_WGT_ScrapTypes]
AS

select distinct
	 MD.[ID]
	,MD.[Description]
	,MDP.[Value]		as [ScrapClassID]
	,MD1.[Description]	as [ScrapClass]
from [dbo].[MaterialDefinition] MD
cross apply(
	select top 1 *
	from [dbo].[MaterialDefinitionProperty]
	where [Description] = N'Вид лома' and [MaterialDefinitionID] = MD.[ID]
	order by [ID] desc
) as MDP
join [dbo].[MaterialDefinition] MD1
on MD.MaterialDefinitionID = MD1.ID
join [dbo].[MaterialClass] MC
on MD1.MaterialClassID = MC.ID
where MC.Code = N'Scrap'

GO