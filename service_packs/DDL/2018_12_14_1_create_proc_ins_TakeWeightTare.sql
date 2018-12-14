
IF OBJECT_ID ('dbo.ins_TakeWeightTare',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_TakeWeightTare;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* take weight Tare */
create PROCEDURE [dbo].[ins_TakeWeightTare]
	 @WeightsheetID int
	,@PackagingUnitsID int
	,@ScalesID int
	,@WeightTare real
	,@DWWagonID int = NULL
	,@Carrying real = NULL
	,@MarkedTare real = NULL
	,@PackagingUnitsDocsID int OUTPUT

as
begin

-- get current Person
declare @PersonID int
select @PersonID = [PersonID] from [dbo].[PersonProperty] where UPPER([Value]) = UPPER(SYSTEM_USER)

if(@PackagingUnitsID is null)
	THROW 60001, N'PackagingUnitsID does not exists', 1;
if(@WeightsheetID is null)
	THROW 60001, N'WeightsheetID param required', 1;
if(@ScalesID is null)
	THROW 60001, N'ScalesID param required', 1;
if(@WeightTare is null)
	THROW 60001, N'WeightTare param required', 1;
if(@PersonID is null)
	THROW 60001, N'Person does not exist!', 1;

BEGIN TRANSACTION ins_TakeWeightTare;
BEGIN TRY

-- если для документа вагона не существует - вставляем вагон
-- если запись этого вагона уже есть - обновляем статус и дату
-- inserting or updating wagon in [PackagingUnitsDocs]
declare @out_id_PUD table ([ID] int)

MERGE INTO [PackagingUnitsDocs]	as trg
USING  
	(select top 1
		 PU.[Description]			as [Description]
		,@WeightsheetID				as [DocumentationsID]
		,PU.ID						as [PackagingUnitsID]
		,null						as [Status]
		,getdate()					as [StartTime]
	from [dbo].[PackagingUnits] PU
	join [dbo].[Documentations] D
	on D.ID = @WeightsheetID and D.[Status] = 'active'
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
INTO @out_id_PUD;
select @PackagingUnitsDocsID = ID from @out_id_PUD




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
where	D.ID = @WeightsheetID and D.[Status] = 'active' and WO.OperationTime < getdate()


-- insert new weighting operation in [WeightingOperations]
declare @out_id_WO table ([ID] int)
declare @WO_ID int

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
	,[MaterialDefinitionID]
	,[TaringTime]
	,[PersonID])
output INSERTED.[ID] INTO @out_id_WO
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
	,getdate()				as [TaringTime]
	,@PersonID				as [PersonID]
from [dbo].[Documentations] D
join [dbo].[DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
join [dbo].[PackagingUnits] PU
on PU.ID = @PackagingUnitsID
where D.ID = @WeightsheetID and D.[Status] = 'active'

select @WO_ID = [ID] from @out_id_WO


-- insert properties in [WeightingOperationsProperty] (only if value has been changed)
insert into [dbo].[WeightingOperationsProperty]
	([Description]
	,[Value]
	,[WeightingOperationsID]
	,[ValueTime])
select
	 T.[Description]
	,T.[Value]
	,WO.[ID]			as [WeightingOperationsID]
	,WO.[OperationTime]	as [ValueTime]
	--,PUP.[Value]		as [PUPValue]
from [dbo].[WeightingOperations] WO
cross apply (values
 (N'Грузоподъемность',	@Carrying)
,(N'Тара с бруса',		@MarkedTare)
) as T([Description], [Value])
-- left join [dbo].[PackagingUnits] PU
-- on WO.[Description] = PU.[Description]
-- left join [dbo].[PackagingUnitsProperty] PUP
-- on PUP.[PackagingUnitsID] = PU.[ID] and T.[Description] = PUP.[Description]

where WO.[ID] = @WO_ID and T.[Value] is not null 
	--and T.[Value] != isnull(PUP.[Value], -9999)



if(@DWWagonID is not null)
Begin
	MERGE INTO [PackagingUnitsDocsProperty]	as trg
	USING  
	(	select
			 @PackagingUnitsDocsID	as [PackagingUnitsDocsID]
			,T1.[Description]
			,T1.[Value]
			,getdate()				as [ValueTime]
		from (values
		(N'DWWagonID',  cast(@DWWagonID as nvarchar))
		) as T1 ([Description], [Value])
	) as src
	ON		trg.[PackagingUnitsDocsID] = src.[PackagingUnitsDocsID] 
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
			,[PackagingUnitsDocsID]
			,[ValueTime])
		VALUES
			(src.[Description]
			,src.[Value]
			,src.[PackagingUnitsDocsID]
			,src.[ValueTime])
	-- output
	OUTPUT 
		'[PackagingUnitsDocsProperty]'												as [Table]
		,$ACTION
		,ISNULL(INSERTED.[Description], DELETED.[Description])						AS [Description] 
		,ISNULL(INSERTED.[Value], DELETED.[Value])									AS [Value] 
		,ISNULL(INSERTED.[PackagingUnitsDocsID], DELETED.[PackagingUnitsDocsID])	AS [PackagingUnitsDocsID]
		,ISNULL(INSERTED.[ValueTime], DELETED.[ValueTime])							AS [ValueTime] 
;
End



COMMIT TRANSACTION  ins_TakeWeightTare; 
END TRY
	
BEGIN CATCH
	ROLLBACK TRANSACTION ins_TakeWeightTare;
	THROW 60020,'Error transaction ins_TakeWeightTare',1;	
END CATCH

end




GO