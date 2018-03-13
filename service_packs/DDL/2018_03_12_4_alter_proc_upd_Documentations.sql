
IF OBJECT_ID ('dbo.upd_Documentations',N'P') IS NOT NULL
  DROP PROCEDURE dbo.upd_Documentations;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[upd_Documentations]
   @DocumentationsID int,
   @Status nvarchar(20)
AS
BEGIN

IF @DocumentationsID IS NULL
THROW 60001, N'DocumentationsID param required', 1;

BEGIN TRANSACTION upd_Documentations;
BEGIN TRY

	UPDATE [dbo].[Documentations]
	SET  
		[Status]	= @Status, 
		[EndTime]	= getdate()
	WHERE  ID = @DocumentationsID


if(@Status = N'closed')
begin

/* При закрытии отвесной (Загрузка или Разгрузка) обновляем св-ва путевых (Вес в отвесной, Использован в отвесной) */
select 
	 cast(WB.Value as int)	as [WaybillID]
	,cast(cast(WO.[Brutto] as nvarchar)+'/'+cast(WO.[Tara] as nvarchar)+'/'+cast((WO.[Netto]) as nvarchar) as nvarchar)	as [Вес в отвесной]
	,cast(@DocumentationsID as nvarchar)	as [Использован в отвесной]
into #WBProp
from [dbo].[WeightingOperations] WO
join [dbo].[PackagingUnitsDocs] PUD
on WO.[PackagingUnitsDocsID] = PUD.[ID]
cross apply(
	select top 1 * 
	from [dbo].[PackagingUnitsDocsProperty] 
	where [PackagingUnitsDocsID] = WO.[PackagingUnitsDocsID] and [Description] = N'Путевая' 
	order by [ID] desc
) as WB
join [dbo].[Documentations] D
on WO.[DocumentationsID] = D.ID
join [dbo].[DocumentationsClass] DC
on DC.[ID] = D.[DocumentationsClassID]
where WO.[DocumentationsID] = @DocumentationsID 
and isnull(WO.[Status], N'') != N'reject' 
and isnull(PUD.[Status], N'') != N'reject' 
and DC.[Description] in (N'Погрузка', N'Разгрузка')
and @Status = N'closed'

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
	 upvt.[Property]	as [Description]
	,upvt.[Value]
	,null				as [ValueUnitofMeasure]
	,null				as [DocumentationsProperty]
	,DCP.ID				as [DocumentationsClassPropertyID]
	,upvt.[WaybillID]	as [DocumentationsID]
	,getdate()			as [ValueTime]
from #WBProp
unpivot(
	[Value] FOR [Property] IN([Вес в отвесной],[Использован в отвесной]) 
) as upvt
inner join [dbo].[DocumentationsClassProperty] DCP
on upvt.[Property] = DCP.[Description]
inner join [dbo].[DocumentationsClass] DC
on DC.[ID] = DCP.[DocumentationsClassID]

-- update Status of Waybill
update D
set [Status] = N'used'
from [dbo].[Documentations] D
join #WBProp T
on D.[ID] = T.[WaybillID]



/* При закрытии отвесной (Тарирование) обновляем Вес тары для вагонов */
;with CTE_src as (
select 
		 N'Вес тары'				as [Description]
		,WO.[Tara]					as [Value]
		,PUD.[PackagingUnitsID]		as [PackagingUnitsID]
		,getdate()					as [ValueTime]
from [dbo].[Documentations] D
join [dbo].[DocumentationsClass] DC
on D.[DocumentationsClassID] = DC.[ID]
join [dbo].[WeightingOperations] WO
on D.[ID] = WO.[DocumentationsID]
join [dbo].[PackagingUnitsDocs] PUD
on WO.[PackagingUnitsDocsID] = PUD.[ID]
where D.[ID]=@DocumentationsID 
	and D.[Status] = N'closed'
	and DC.[Description] = N'Тарирование' 
	and isnull(WO.[Status], '') != N'reject'
)

-- если св-во Вес тары для вагона существует - обновляем значение и дату
-- если св-во не существует - вставляем его
-- updating Tare value in [PackagingUnitsProperty]
MERGE INTO [PackagingUnitsProperty]	as trg
USING CTE_src as src
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


end 


COMMIT TRANSACTION  upd_Documentations; 
END TRY
	
BEGIN CATCH
	ROLLBACK TRANSACTION upd_Documentations;
	declare @err nvarchar(500) = ERROR_MESSAGE();
	set @err = N'Error transaction upd_Documentations. \n\r' + @err;
	THROW 60020,@err,1;	
END CATCH
        
END

GO

/* Drop old trigger for updating Tare */
IF OBJECT_ID ('dbo.updDocumentationsStatus',N'TR') IS NOT NULL
	DROP TRIGGER [dbo].[updDocumentationsStatus]
GO


