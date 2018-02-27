
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
	where WO.[OperationType] = N'Тарирование' and isnull(WO.[Status], '') != N'reject' and WO.[Tara] > 0
)


update WO
set 
	 WO.[Tara] = TARE.[Value]
	,WO.[Netto] = WO.[Brutto] - TARE.[Value]
	,WO.[TaringTime] = TARE.[ValueTime]

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

COMMIT TRANSACTION  ins_TakeWeightUnloadingTare; 
END TRY
	
BEGIN CATCH
	ROLLBACK TRANSACTION ins_TakeWeightUnloadingTare;
	THROW 60020,'Error transaction ins_TakeWeightUnloadingTare',1;	
END CATCH
end




