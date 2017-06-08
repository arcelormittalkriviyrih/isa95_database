
IF OBJECT_ID ('dbo.ins_TakeWeightTare',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_TakeWeightTare;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/* take weight Tare */
create PROCEDURE [dbo].[ins_TakeWeightTare]
	 @WeightSheetID int
	,@PackagingUnitsID int
	,@ScalesID int
	,@WeightTare real
	,@PackagingUnitsDocsID int OUTPUT

as
begin

if(@PackagingUnitsID is null)
	THROW 60001, N'PackagingUnitsID does not exists', 1;
if(@WeightSheetID is null)
	THROW 60001, N'WeightSheetID param required', 1;
if(@ScalesID is null)
	THROW 60001, N'ScalesID param required', 1;
if(@WeightTare is null)
	THROW 60001, N'WeightTare param required', 1;

BEGIN TRANSACTION ins_TakeWeightTare;
BEGIN TRY
/*
SET @PackagingUnitsDocsID = NEXT VALUE FOR [dbo].[gen_PackagingUnitsDocs];

-- insert new wagon in [PackagingUnitsDocs]
insert into [dbo].[PackagingUnitsDocs]
	([ID]
	,[Description]
	,[DocumentationsID]
	,[PackagingUnitsID]
	,[Status]
	,[StartTime])
select top 1
	 @PackagingUnitsDocsID		as [ID]
	,PU.[Description]			as [Description]
	,@WeightSheetID				as [DocumentationsID]
	,PU.ID						as [PackagingUnitsID]
	,null						as [Status]
	,getdate()					as [StartTime]
from [dbo].[PackagingUnits] PU
join [dbo].[Documentations] D
on D.ID = @WeightSheetID and D.[Status] = 'active'
where PU.ID = @PackagingUnitsID
*/


/*OK*/
-- если для документа вагона не существует - вставляем вагон
-- если запись этого вагона уже есть - обновляем статус и дату
-- inserting or updating wagon in [PackagingUnitsDocs]
declare @out_id_table table ([ID] int)

MERGE INTO [PackagingUnitsDocs]	as trg
USING  
	(select top 1
		 PU.[Description]			as [Description]
		,@WeightSheetID				as [DocumentationsID]
		,PU.ID						as [PackagingUnitsID]
		,null						as [Status]
		,getdate()					as [StartTime]
	from [dbo].[PackagingUnits] PU
	join [dbo].[Documentations] D
	on D.ID = @WeightSheetID and D.[Status] = 'active'
	where PU.ID = @PackagingUnitsID
) as src
ON		trg.[DocumentationsID] = src.[DocumentationsID]
	and trg.[PackagingUnitsID] = src.[PackagingUnitsID]
-- если есть сопоставление строки trg со строкой из источника src
WHEN MATCHED  THEN 
	UPDATE SET
		 trg.[Status] = src.[Status]
		,trg.[StartTime] = src.[StartTime]
-- если строка не найдена в trg, но есть в src
WHEN NOT MATCHED THEN 
	INSERT
		([Description]
		,[DocumentationsID]
		,[PackagingUnitsID]
		,[Status]
		,[StartTime])
	VALUES
		(src.[Description]
		,src.[DocumentationsID]
		,src.[PackagingUnitsID]
		,src.[Status]
		,src.[StartTime])
-- output
OUTPUT
	ISNULL(INSERTED.[ID], DELETED.[ID])		AS [ID]
INTO @out_id_table;
select @PackagingUnitsDocsID = ID from @out_id_table


--select * from [dbo].[PackagingUnitsDocs] --where ID = @PackagingUnitsDocsID




/*OK*/
-- запись операции взвешивания
-- если для документа запись вагона уже есть - забраковываем предыдущие записи для этого вагона, а новую - вставляем
-- если для документа вагона записи еще нет - вставляем.

-- update status for repeating wagons in this document
update WO
	set WO.Status = 'reject'
from [dbo].[Documentations] D
join [dbo].[DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
join [dbo].[PackagingUnits] PU
on PU.ID = @PackagingUnitsID
join [WeightingOperations] WO
on WO.DocumentationsID = D.ID and WO.PackagingUnitsDocsID = @PackagingUnitsDocsID
where	D.ID = @WeightSheetID and D.[Status] = 'active' and WO.OperationTime < getdate()


-- insert new weighting operation in [WeightingOperations]
insert into [dbo].[WeightingOperations]
	([Description]
	,[OperationTime]
	,[Status]
	,[EquipmentID]
	,[PackagingUnitsDocsID]
	,[DocumentationsID]
	,[Brutto]
	,[Tara]
	,[Netto]
	,[OperationType]
	,[MaterialDefinitionID])
select top 1
	 PU.[Description]		as [Description]
	,getdate()				as [OperationTime]
	,null					as [Status]
	,@ScalesID				as [EquipmentID]
	,@PackagingUnitsDocsID	as [PackagingUnitsDocsID]
	,D.ID					as [DocumentationsID]
	,null					as [Brutto]
	,@WeightTare			as [Tara]
	,null					as [Netto]
	,DC.[Description]		as [OperationType]
	,null					as [MaterialDefinitionID]
from [dbo].[Documentations] D
join [dbo].[DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
join [dbo].[PackagingUnits] PU
on PU.ID = @PackagingUnitsID
where D.ID = @WeightSheetID and D.[Status] = 'active'

--select * from [dbo].[WeightingOperations] where [DocumentationsID] = @WeightSheetID


/*OK*/
-- если св-во Вес тары для вагона существует - обновляем значение и дату
-- если св-во не существует - вставляем его
-- updating Tare value in [PackagingUnitsProperty]
MERGE INTO [PackagingUnitsProperty]	as trg
USING  
(	select
		 N'Вес тары'		as [Description]
		,@WeightTare		as [Value]
		,@PackagingUnitsID	as [PackagingUnitsID]
		,getdate()			as [ValueTime]
) as src
ON		trg.PackagingUnitsID = src.PackagingUnitsID 
	and trg.[Description] = src.[Description]
-- если есть сопоставление строки trg со строкой из источника src
WHEN MATCHED THEN 
	UPDATE SET
		 trg.[Value] = src.[Value]
		,trg.[ValueTime] = src.[ValueTime]	  	  		  
-- если строка не найдена в trg, но есть в src
WHEN NOT MATCHED BY TARGET THEN 
	INSERT
		([Description]
		,[Value]
		,[PackagingUnitsID]
		,[ValueTime])
	VALUES
		(src.[Description]
		,src.[Value]
		,src.[PackagingUnitsID]
		,src.[ValueTime])
-- output
OUTPUT 
	 $ACTION
	,ISNULL(INSERTED.[Description], DELETED.[Description])				AS [Description] 
	,ISNULL(INSERTED.[Value], DELETED.[Value])							AS [Value] 
	,ISNULL(INSERTED.[PackagingUnitsID], DELETED.[PackagingUnitsID])	AS [PackagingUnitsID]
	,ISNULL(INSERTED.[ValueTime], DELETED.[ValueTime])					AS [ValueTime] 
;

COMMIT TRANSACTION  ins_TakeWeightTare; 
END TRY
	
BEGIN CATCH
	ROLLBACK TRANSACTION ins_TakeWeightTare;
	THROW 60020,'Error transaction ins_TakeWeightTare',1;	
END CATCH

end




GO