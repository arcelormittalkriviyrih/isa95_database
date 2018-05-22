
IF OBJECT_ID ('dbo.upd_SaveWaybill',N'P') IS NOT NULL
  DROP PROCEDURE dbo.upd_SaveWaybill;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

*/
create PROCEDURE [dbo].[upd_SaveWaybill]

   @WaybillNumber		nvarchar(10),
   @Consigner			nvarchar(100),  

   @WagonType			int,
   @WagonNumber			int,
   @CargoType			int,
   @CargoTypeNotes		nvarchar(250),

   @SenderShop			int,          
   @SenderDistrict		int,        
   @SenderRWStation		int,       
   @SenderArriveDT		datetime,   
   @SenderStartLoadDT	datetime,
   @SenderEndLoadDT		datetime,  

   @ReceiverShop		int,        
   @ReceiverDistrict	int,      
   @ReceiverRWStation	int,     
   @ReceiverArriveDT	datetime, 
   @ReceiverStartLoadDT datetime,  
   @ReceiverEndLoadDT	datetime,

   @DocumentationsID 	int,
   @DocumentationsID_returned int OUTPUT
AS
BEGIN
	IF not exists(select ID from [dbo].[Documentations] where ID = @DocumentationsID)
		THROW 60001, N'Document does not exists', 1;

	IF (isnull(@WaybillNumber, '') = '')
		THROW 60001, N'WaybillNumber param required', 1;
	IF @WagonType IS NULL
		THROW 60001, N'WagonType param required', 1;
	IF @WagonNumber IS NULL
		THROW 60001, N'WagonNumber param required', 1;
	IF @CargoType IS NULL
		THROW 60001, N'CargoType param required', 1;
	IF @SenderShop IS NULL
		THROW 60001, N'SenderShop param required', 1;
	IF @SenderDistrict IS NULL
		THROW 60001, N'SenderDistrict param required', 1;
	IF @SenderRWStation IS NULL
		THROW 60001, N'SenderRWStation param required', 1;
	IF @ReceiverShop IS NULL
		THROW 60001, N'ReceiverShop param required', 1;
	IF @ReceiverDistrict IS NULL
		THROW 60001, N'ReceiverDistrict param required', 1;
	IF @ReceiverRWStation IS NULL
		THROW 60001, N'ReceiverRWStation param required', 1;
	--IF @ParamName IS NULL
	--	THROW 60001, N'ParamName required', 1;	

	BEGIN TRANSACTION upd_SaveWaybill;
	BEGIN TRY 

	-- insert Waybill new properties
	insert into [dbo].[DocumentationsProperty]
		([Description]
		,[Value]
		,[ValueUnitofMeasure]
		,[DocumentationsProperty]
		,[DocumentationsClassPropertyID]
		,[DocumentationsID]
		,[ValueTime])	
	SELECT 
		 isnull(new.[Description], vWP.[Description]) as [Description]
		,new.[Value]
		,null				as [ValueUnitofMeasure]
		,null				as [DocumentationsProperty]
		,DCP.ID				as [DocumentationsClassPropertyID]
		,@DocumentationsID	as [DocumentationsID]
		,getdate()			as [ValueTime]
	FROM
	(values
			 (N'Номер путевой',										N'WaybillNumber'		, cast(@WaybillNumber as nvarchar))
			--,(N'Приемосдатчик',										N'Consigner'			, cast(@Consigner as nvarchar))
			,(N'Род вагона',										N'WagonType'			, cast(@WagonType as nvarchar))
			,(N'Род груза',											N'CargoType'			, cast(@CargoType as nvarchar))
			,(N'Цех отправления',									N'SenderShop'			, cast(@SenderShop as nvarchar))
			,(N'Место погрузки',									N'SenderDistrict'		, cast(@SenderDistrict as nvarchar))
			,(N'Станция отправления',								N'SenderRWStation'		, cast(@SenderRWStation as nvarchar))
			,(N'Время прибытия (станция отправления)',				N'SenderArriveDT'		, convert(nvarchar, convert(datetime, @SenderArriveDT), 126))--cast(@SenderArriveDT as nvarchar))
			,(N'Время подачи под погрузку (станция отправления)',	N'SenderStartLoadDT'	, convert(nvarchar, convert(datetime, @SenderStartLoadDT), 126))--cast(@SenderStartLoadDT as nvarchar))
			,(N'Время окончания выгрузки (станция отправления)',	N'SenderEndLoadDT'		, convert(nvarchar, convert(datetime, @SenderEndLoadDT), 126))--cast(@SenderEndLoadDT as nvarchar))
			,(N'Цех получения',										N'ReceiverShop'			, cast(@ReceiverShop as nvarchar))
			,(N'Место выгрузки',									N'ReceiverDistrict'		, cast(@ReceiverDistrict as nvarchar))
			,(N'Станция назначения',								N'ReceiverRWStation'	, cast(@ReceiverRWStation as nvarchar))
			,(N'Время прибытия (станция назначения)',				N'ReceiverArriveDT'		, convert(nvarchar, convert(datetime, @ReceiverArriveDT), 126))--cast(@ReceiverArriveDT as nvarchar))
			,(N'Время подачи под погрузку (станция назначения)',	N'ReceiverStartLoadDT'	, convert(nvarchar, convert(datetime, @ReceiverStartLoadDT), 126))--cast(@ReceiverStartLoadDT as nvarchar))
			,(N'Время окончания выгрузки (станция назначения)',		N'ReceiverEndLoadDT'	, convert(nvarchar, convert(datetime, @ReceiverEndLoadDT), 126))--cast(@ReceiverEndLoadDT as nvarchar))
			,(N'Примечание к роду груза',							N'CargoType'			, cast(@CargoTypeNotes as nvarchar))	
	) as new ([Description], [Description2], [Value])
	full join [dbo].[v_WGT_WaybillProperty] vWP
	on vWP.[Description2] = new.[Description2]		
	inner join [dbo].[DocumentationsClassProperty] DCP
	on new.[Description] = DCP.[Description]
	where isnull(vWP.[value], '') !=isnull(new.[value], '') and [DocumentationsID] = @DocumentationsID

	-- update Modify date and Waybill description
	update D
	set 
		 D.[Description] = N'Путевая №' + @WaybillNumber
		,D.[EndTime] = getdate()
	--select *,
	--	 @DocumentationsID				as [ID]
	--	,N'Путевая №' + @WaybillNumber	as [Description]
	--	,[EndTime]						as [EndTime]
	FROM [dbo].[Documentations] D
	join [dbo].[v_WGT_WaybillProperty] vWP
	on D.ID = vWP.DocumentationsID
	where vWP.[Description2] = N'WaybillNumber' /*and vWP.[Value2] != @WaybillNumber*/ and D.[ID] = @DocumentationsID


	-- insert new Wagon in [PackagingUnitsDocs]
	MERGE INTO [PackagingUnitsDocs]	as trg
	USING  
	(
		select
			 (select top 1 [Description] from [dbo].[PackagingUnits] where [ID] = @WagonNumber) as [Description]
			,@DocumentationsID	as DocumentationsID
			,@WagonNumber		as PackagingUnitsID
			,null				as [Status]
			,getdate()			as [StartTime]
	) as src
	ON	src.DocumentationsID = trg.DocumentationsID 
	and trg.PackagingUnitsID = src.PackagingUnitsID
	---- если есть сопоставление строки trg со строкой из источника src
	--WHEN MATCHED THEN 
	--	UPDATE SET
	--	 trg.[StartTime] = src.[StartTime]	 	  		  
	-- если строка не найдена в trg, но есть в src
	WHEN NOT MATCHED BY TARGET THEN 
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
	-- если строка не найдена в src, но есть в trg
	WHEN NOT MATCHED BY SOURCE and trg.[DocumentationsID] = @DocumentationsID THEN 	 
		 UPDATE SET
		 trg.[Status] = 'reject'
	---- output
	--OUTPUT 
	--	 $ACTION
	--	,ISNULL(INSERTED.[Description], DELETED.[Description])				AS [Description] 
	--	,ISNULL(INSERTED.[DocumentationsID], DELETED.[DocumentationsID])	AS [DocumentationsID] 
	--	,ISNULL(INSERTED.[PackagingUnitsID], DELETED.[PackagingUnitsID])	AS [PackagingUnitsID] 
	--	,ISNULL(INSERTED.[Status], DELETED.[Status])						AS [Status] 
	--	,ISNULL(INSERTED.[StartTime], DELETED.[StartTime])					AS [StartTime] 
;
	
	
	/*
	select
		 [ID]
		,[Description]
		,[Value]
		,[DocumentationsID]
		,cast([ValueTime] as smalldatetime) as [ValueTime]
		,[DocumentationsClassPropertyID]
		,row_number() over (partition by [DocumentationsClassPropertyID] order by ID desc) as RN
	from [dbo].[DocumentationsProperty]
	where [DocumentationsID] = @DocumentationsID

	select *
	FROM [dbo].[v_WGT_WaybillProperty]
	where [DocumentationsID] = @DocumentationsID
	
	select *
	FROM [dbo].[PackagingUnitsDocs]
	where [DocumentationsID] = @DocumentationsID
	*/

	select @DocumentationsID_returned = @DocumentationsID	
	--ROLLBACK TRANSACTION upd_SaveWaybill;
	COMMIT TRANSACTION  upd_SaveWaybill; 
	END TRY
		
	BEGIN CATCH
		ROLLBACK TRANSACTION upd_SaveWaybill;
		THROW 60020,'Error transaction upd_SaveWaybill',1;	
	END CATCH
	
END



GO