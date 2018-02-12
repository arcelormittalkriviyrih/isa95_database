SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_WGT_DocumentationsExistCheck',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_DocumentationsExistCheck];
GO

/*
   View: v_WGT_DocumentationsExistCheck
   Возвращает основные данные по документам за последний год
*/
CREATE view [dbo].[v_WGT_DocumentationsExistCheck]
as

select
	 [DocumentationsID] as [ID]
	,case 
		when isnumeric([WeightsheetNumber]) = 1
		then cast([WeightsheetNumber] as int)
		else 0
	 end								as [WeightsheetNumber]
	,case 
		when isnumeric([WaybillNumber]) = 1
		then cast([WaybillNumber] as int)
		else 0
	 end								as [WaybillNumber]
	,[Weightbridge]
	,[SenderShop]
	,[ReceiverShop]
	,D.[StartTime]
	,D.[EndTime]
	,D.[Status]
	,DC.[ID]			as [DocumentationsClassID]
	,case 
		when DC.ParentID is null
		then DC.[Description]
		else DC1.[Description]
	 end				as [DocumentationsType]
from (
	select 
		 [DocumentationsID]
		,[Description2]
		,[Value]
	from [dbo].[v_WGT_DocumentsProperty] 
) as WP
pivot(max(Value) for [Description2] in ([WeightsheetNumber], [WaybillNumber], [Weightbridge], [SenderShop], [ReceiverShop])) as pvt
inner join
[dbo].[Documentations] D
on pvt.[DocumentationsID] = D.ID --and isnull(D.[EndTime], getdate()) > dateadd(year, -1, getdate())
inner join [DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
left join [DocumentationsClass] DC1
on DC.ParentID = DC1.ID
--where DC1.[Description] = N'Отвесная'


GO


