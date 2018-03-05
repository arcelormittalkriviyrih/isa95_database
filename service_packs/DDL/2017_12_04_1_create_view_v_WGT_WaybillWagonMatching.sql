
IF OBJECT_ID ('dbo.v_WGT_WaybillWagonMatching',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WaybillWagonMatching];
GO

/*
   View: v_WGT_WaybillWagonMatching
   Возвращает путевые и содержащиеся в них вагоны
*/
create view [dbo].[v_WGT_WaybillWagonMatching] as 

select --distinct
	 PUD.[ID]
	,PUD.[Description]	as [WagonNumber]
	,PUD.[PackagingUnitsID]
	,PUD.[DocumentationsID]	as [WaybillID]
	--,DC.*
	,P.[WaybillNumber]
	,P.[SenderShop]
	,P.[ReceiverShop]
	,D.[StartTime]
	,D.[Status]
from [dbo].[PackagingUnitsDocs] PUD
join [dbo].[Documentations] D
on PUD.[DocumentationsID] = D.[ID]
join [dbo].[DocumentationsClass] DC
on D.[DocumentationsClassID] = DC.[ID]
join (
select
	 [DocumentationsID]
	,[WaybillNumber]
	,[SenderShop]
	,[ReceiverShop]
from (
	select 
		 [DocumentationsID]
		,[Description2]
		,[Value]   
	from [dbo].[v_WGT_DocumentsProperty]) DP
pivot (max([Value]) for [Description2] in ([WaybillNumber], [SenderShop], [ReceiverShop])) as pvt
) as P
on P.[DocumentationsID] = D.[ID]
where DC.[Description] = N'Путевая' and isnull(D.[Status], '') not in (N'reject'/*, N'used'*/)
--order by D.[EndTime] desc

GO