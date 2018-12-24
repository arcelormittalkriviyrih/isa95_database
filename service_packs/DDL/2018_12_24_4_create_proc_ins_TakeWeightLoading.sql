
IF OBJECT_ID ('dbo.ins_TakeWeightLoading',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_TakeWeightLoading;
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*
	Procedure: ins_TakeWeightLoading
	Процедура регистрации веса в отвесную при погрузке
*/

create PROCEDURE [dbo].[ins_TakeWeightLoading]
	 @WeightsheetID int			-- weightsheet
	,@WaybillID int				-- waybill
	,@ScalesID int				-- scales
	,@WeightBrutto real			-- brutto
	,@DWWagonID int = NULL
	--,@PackagingUnitsID int		-- wagon
	--,@MaterialDefinitionID int	-- cargo type
as
begin

declare 
	 @PackagingUnitsID int		-- wagon
	,@MaterialDefinitionID int	-- cargo type
	,@SenderID int				-- sender shop
	,@ReceiverID int			-- receiver shop
	,@PackagingUnitsDocsID int
	,@WeightTare real
	,@TareDT datetime
	,@PersonID int
	,@TarePersonID int

;with CTE_WaybillProperty as (
select 
	 vDP.[ID]
    ,vDP.[DocumentationsID]
    ,vDP.[Description]
	,vDP.[Description2]
    ,vDP.[Value]
	,row_number() over (partition by vDP.[DocumentationsID], vDP.[Description] order by vDP.[ValueTime] desc) RN
from [dbo].[v_WGT_DocumentsProperty] vDP
join [Documentations] D
on vDP.[DocumentationsID] = D.ID
where	isnull(D.[Status], '') != 'reject'
	and D.ID = @WaybillID )

-- get CargoType, Sender and Receiver from Waybill properties
select 
	-- [DocumentationsID]
	--,[WaybillNumber]
	--,[WagonType]
	 @MaterialDefinitionID = [CargoType]
	,@SenderID = [SenderShop]
	,@ReceiverID = [ReceiverShop]
from 
(select [DocumentationsID], [Description2],[Value] from CTE_WaybillProperty where RN = 1) as src
pivot (max([Value]) for [Description2] in ([WaybillNumber], [WagonType], [CargoType], [SenderShop], [ReceiverShop])
) as pvt

-- get WagonID from Waybill properties
select top 1
	@PackagingUnitsID = PUD.PackagingUnitsID	 
from [PackagingUnitsDocs] PUD
join [Documentations] D
on PUD.[DocumentationsID] = D.ID
where	isnull(D.[Status], '') != 'reject'
	and isnull(PUD.[Status], '') != 'reject'
	and D.ID = @WaybillID
order by PUD.ID desc

-- get Tare, its Datetime and TareWeigher
select top 1
	 @WeightTare = PUP.[Value]
	,@TareDT = PUP.[ValueTime]
	,@TarePersonID = WO.[PersonID]
from [dbo].[PackagingUnits] PU
join [PackagingUnitsProperty] PUP
on PU.[ID] = PUP.[PackagingUnitsID]
left join [dbo].[WeightingOperations] WO
on WO.[Description] = PU.[Description] and WO.[OperationType] = N'Тарирование' and WO.[Tara] = PUP.[Value] and WO.[OperationTime] = PUP.[ValueTime]
where	PUP.[PackagingUnitsID] = @PackagingUnitsID
	and PUP.[Description] = N'Вес тары'
order by PUP.[ID] desc

-- get current Person
select @PersonID = [PersonID] 
from [dbo].[PersonProperty] 
where UPPER([Value]) = UPPER(SYSTEM_USER)


-- check validations
if(@WeightSheetID is null)
	THROW 60001, N'WeightSheetID param required', 1;
if(@WaybillID is null)
	THROW 60001, N'WaybillID param required', 1;
if(@ScalesID is null)
	THROW 60001, N'ScalesID param required', 1;
if(@MaterialDefinitionID is null)
	THROW 60001, N'MaterialDefinitionID param required', 1;
if(@PackagingUnitsID is null)
	THROW 60001, N'PackagingUnitsID param required', 1;
if(@SenderID is null)
	THROW 60001, N'@SenderID param required', 1;
if(@ReceiverID is null)
	THROW 60001, N'@ReceiverID param required', 1;
if(@WeightBrutto is null)
	THROW 60001, N'WeightBrutto param required', 1;
if(@WeightBrutto-@WeightTare < 0)
	THROW 60001, N'Netto weight < 0!', 1;
if(@PersonID is null)
	THROW 60001, N'Person does not exist!', 1;

/* checking Weightsheet type */
if not exists
(	select D.ID
	from [dbo].[Documentations] D
	join [dbo].[DocumentationsClass] DC
	on DC.ID = [DocumentationsClassID]
	where DC.[Description] = N'Погрузка' and D.ID = @WeightSheetID)
	THROW 60001, N'Documentation type error', 1;

/* checking of equal sender and receiver properties of waybill and weightsheet*/
if (
	select count(Prop.[Description])
	from (values
	(N'Цех отправления'),
	(N'Цех получения')
	) as Prop ([Description])
	left join [dbo].[v_WGT_DocumentsProperty] vDP_WB
	on vDP_WB.[Description] = Prop.[Description] and vDP_WB.[DocumentationsID] = @WaybillID
	left join [dbo].[v_WGT_DocumentsProperty] vDP_WS
	on vDP_WS.[Description] = Prop.[Description] and vDP_WS.[DocumentationsID] = @WeightSheetID
	where isnull(vDP_WB.[Value],'') != isnull(vDP_WS.[Value],'')
) > 0
	THROW 60001, N'Sender or Receiver in Weightsheet and Waybill are not equal!', 1;


BEGIN TRANSACTION ins_TakeWeightLoading;
BEGIN TRY

--select 
--	 @PackagingUnitsID		as [PackagingUnitsID]
--	,@MaterialDefinitionID	as [MaterialDefinitionID]
--	,@SenderID				as [SenderID]
--	,@ReceiverID			as [ReceiverID]
--	,@WeightTare			as [WeightTare]
--	,@WeightBrutto			as [WeightBrutto]


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



-- если св-во 'Путевая' и 'Род груза' для вагона существует - обновляем значение и дату
-- если св-во не существует - вставляем его
-- updating Properties in [PackagingUnitsDocsProperty]
MERGE INTO [PackagingUnitsDocsProperty]	as trg
USING  
(	select
		 @PackagingUnitsDocsID	as [PackagingUnitsDocsID]
		,T1.[Description]
		,T1.[Value]
		,getdate()				as [ValueTime]
	from (values
	(N'Путевая',	cast(@WaybillID as nvarchar)),
	(N'Род груза',  cast(@MaterialDefinitionID as nvarchar))
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



-- запись операции взвешивания
-- если для документа запись вагона уже есть - забраковываем предыдущие записи для этого вагона, а новую - вставляем
-- если для документа вагона записи еще нет - вставляем.

-- update status for repeating wagons in this document
update WO
	set WO.[Status] = 'reject'
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
	,[MaterialDefinitionID]
	,[TaringTime]
	,[PersonID]
	,[TaringPersonID])
select top 1
	 PU.[Description]			as [Description]
	,getdate()					as [OperationTime]
	,null						as [Status]
	,@ScalesID					as [EquipmentID]
	,@PackagingUnitsDocsID		as [PackagingUnitsDocsID]
	,D.ID						as [DocumentationsID]
	,@WeightBrutto				as [Brutto]
	,@WeightTare				as [Tara]
	,@WeightBrutto-@WeightTare	as [Netto]
	,DC.[Description]			as [OperationType]
	,@MaterialDefinitionID		as [MaterialDefinitionID]
	,@TareDT					as [TaringTime]
	,@PersonID					as [PersonID]
	,@TarePersonID				as [TaringPersonID]
from [dbo].[Documentations] D
join [dbo].[DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
join [dbo].[PackagingUnits] PU
on PU.ID = @PackagingUnitsID
where D.ID = @WeightSheetID and D.[Status] = 'active'



--DWWW
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
--select * from [dbo].[WeightingOperations] where [DocumentationsID] = @WeightSheetID


COMMIT TRANSACTION  ins_TakeWeightLoading; 
END TRY
	
BEGIN CATCH
	ROLLBACK TRANSACTION ins_TakeWeightLoading;
	declare @err nvarchar(500) = ERROR_MESSAGE();
	set @err = N'Error transaction ins_TakeWeightLoading. \n\r' + @err;
	THROW 60020,@err,1;	
END CATCH
end





GO