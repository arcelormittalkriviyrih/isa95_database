
IF OBJECT_ID ('dbo.ins_TakeWeightUnloadingTare',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_TakeWeightUnloadingTare;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	Procedure: ins_TakeWeightUnloadingTare
	Процедура обновления тары для отвесной при разгрузке
*/


/* update tare for unloading */
create PROCEDURE [dbo].[ins_TakeWeightUnloadingTare] 
	 @WeightsheetID int			-- weightsheet
as
begin

/* add checking Weightsheet type */
if not exists
(	select D.ID
	from [dbo].[Documentations] D
	join [dbo].[DocumentationsClass] DC
	on DC.ID = [DocumentationsClassID]
	where DC.[Description] = N'Разгрузка' and D.ID = @WeightSheetID)
	THROW 60001, N'Documentation type error', 1;


BEGIN TRANSACTION ins_TakeWeightUnloadingTare;
BEGIN TRY
-- temp table for updated WO IDs
declare @upd_WO_IDs table ([ID] int)

-- CTE with all wagons Tare
;with CTE_Tare as (
	-- Tare from [PackagingUnits] (if came from External sources)
	select
		 PU.[ID]
		,PU.[Description]
		,PUP.[Value]
		,PUP.[ValueTime]
		,N'PUP'	as [src]
	from 
	[dbo].[PackagingUnits] PU
	left join [dbo].[PackagingUnitsProperty] PUP
	on PUP.PackagingUnitsID = PU.ID
	where PUP.Description = N'Вес тары' and PUP.ValueTime is not null

	union all
	-- Tare from [WeightingOperations] table
	select 
		 PUD.[PackagingUnitsID]	as [ID]
		,WO.[Description]		as [Description]
		,WO.[Tara]				as [Value]
		,isnull(WO.[TaringTime], WO.[OperationTime]) as [ValueTime]
		,N'WO'
	from [dbo].[WeightingOperations] WO
	join [dbo].[PackagingUnitsDocs] PUD
	on WO.[PackagingUnitsDocsID] = PUD.[ID]
	join [dbo].[Documentations] D
	on WO.[DocumentationsID] = D.[ID]
	where WO.[OperationType] = N'Тарирование' 
		and isnull(WO.[Status], '') != N'reject' 
		and WO.[Tara] > 0 
		and D.[Status] = N'closed'
)

-- update Tare and Netto info for each row in WO for this Weightsheet (if Tare exists)
update WO
set 
	 WO.[Tara] = TARE.[Value]
	,WO.[Netto] = WO.[Brutto] - TARE.[Value]
	,WO.[TaringTime] = TARE.[ValueTime]
output inserted.[ID] into @upd_WO_IDs
from [dbo].[WeightingOperations] WO
outer apply
(	-- first Tare after Brutting for each wagon
	select top 1 
		 [Description]
		,[Value]
		,[ValueTime]
	from CTE_Tare CTE 
	where CTE.[Description] = WO.[Description] and CTE.[ValueTime] > WO.[OperationTime] order by CTE.[ValueTime]
) as TARE
where	WO.[OperationType] = N'Разгрузка' 
	and WO.[Tara] is null
	--and TARE.[Value] is not null
	and WO.[Brutto] - TARE.[Value] > 0		-- Netto > 0
	and isnull(WO.[Status], '') != N'reject' 
	and WO.[DocumentationsID] = @WeightSheetID


-- insert Waybill properties
insert into [dbo].[DocumentationsProperty]
	([Description]
	,[Value]
	,[ValueUnitofMeasure]
	,[DocumentationsProperty]
	,[DocumentationsClassPropertyID]
	,[DocumentationsID]
	,[ValueTime])	
select 
	 DCP.Description	as [Description]
	,cast(WO.[Brutto] as nvarchar) + '/' + cast(WO.[Tara] as nvarchar) + '/' + cast(WO.[Netto] as nvarchar)			as [Value]
	,null				as [ValueUnitofMeasure]
	,null				as [DocumentationsProperty]
	,DCP.ID				as [DocumentationsClassPropertyID]
	,PUDP.[WaybillID]	as [DocumentationsID]
	,getdate()			as [ValueTime]
from [dbo].[WeightingOperations] WO
join @upd_WO_IDs U
on WO.[ID] = U.[ID]
outer apply(
	select top 1 
		 N'Вес в отвесной'	as [Description]
		,[Value]			as [WaybillID] 
	from [dbo].[PackagingUnitsDocsProperty] PUDP
	where PUDP.[Description]= N'Путевая' and PUDP.[PackagingUnitsDocsID] = WO.[PackagingUnitsDocsID]
) as PUDP
inner join [dbo].[DocumentationsClassProperty] DCP
on PUDP.[Description] = DCP.[Description]
inner join [dbo].[DocumentationsClass] DC
on DC.[ID] = DCP.[DocumentationsClassID]
where DC.[Description] = N'Путевая'

COMMIT TRANSACTION  ins_TakeWeightUnloadingTare; 
END TRY
	
BEGIN CATCH
	ROLLBACK TRANSACTION ins_TakeWeightUnloadingTare;
	THROW 60020,'Error transaction ins_TakeWeightUnloadingTare',1;	
END CATCH
end


