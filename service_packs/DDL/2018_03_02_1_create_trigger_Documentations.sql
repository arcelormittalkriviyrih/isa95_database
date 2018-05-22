SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.updDocumentationsStatus',N'TR') IS NOT NULL
	DROP TRIGGER [dbo].[updDocumentationsStatus]
GO

CREATE TRIGGER [dbo].[updDocumentationsStatus] ON [dbo].[Documentations]
AFTER UPDATE
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

if update([Status])
begin
	
	-- при закрытии отвесной для Тарирования обновляем Вес тары для вагонов
	with CTE_src as (
	select 
			 N'Вес тары'				as [Description]
			,WO.[Tara]					as [Value]
			,PUD.[PackagingUnitsID]		as [PackagingUnitsID]
			,getdate()					as [ValueTime]
	--from [dbo].[Documentations] D
	from inserted I join deleted D on I.[ID] = D.[ID]
	join [dbo].[DocumentationsClass] DC
	on D.[DocumentationsClassID] = DC.[ID]
	join [dbo].[WeightingOperations] WO
	on D.[ID] = WO.[DocumentationsID]
	join [dbo].[PackagingUnitsDocs] PUD
	on WO.[PackagingUnitsDocsID] = PUD.[ID]
	where I.[Status] != D.[Status] and I.[Status] = N'closed'
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


END