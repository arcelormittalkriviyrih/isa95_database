
IF OBJECT_ID ('dbo.v_WGT_WaybillExistCheck',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WaybillExistCheck];
GO

/*
   View: v_WGT_WaybillExistCheck
   Возвращает основные данные по путевым за последний год
*/
CREATE view [dbo].[v_WGT_WaybillExistCheck]
as

select --top 1
	 [DocumentationsID] as [ID]
	,[WaybillNumber]
	,[SenderShop]
	,[ReceiverShop]
	,D.[Status]
	,D.[EndTime]
from (
	select 
		 [DocumentationsID]
		,[Description2]
		,[Value]
	from [dbo].[v_WGT_DocumentsProperty] 
) as WP
pivot(max(Value) for [Description2] in ([WaybillNumber], [SenderShop], [ReceiverShop])) as pvt
inner join
[dbo].[Documentations] D
on pvt.[DocumentationsID] = D.ID and D.[EndTime] > dateadd(year, -1, getdate())
inner join [DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
where DC.[Description] = N'Путевая'

GO