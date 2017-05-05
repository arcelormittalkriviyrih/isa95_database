
IF OBJECT_ID ('dbo.ins_SaveWaybill',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_SaveWaybill;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
create PROCEDURE [dbo].[ins_SaveWaybill]
   @WaybillNumber		nvarchar(10),
   @Consigner			nvarchar(100),  

   @WagonType			int,
   @WagonNumber			int,
   @CargoType			int,

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

   @DocumentationsID int OUTPUT		--returned value
AS
BEGIN
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


	BEGIN TRANSACTION ins_SaveWaybill;
	BEGIN TRY 
		SET @DocumentationsID = NEXT VALUE FOR [dbo].[gen_Documentations];

		--- insert Waybill main info into [Documentations]
		insert into [dbo].[Documentations]
			([ID]
			,[Description]
			,[Status]
			,[DocumentationsClassID]
			,[StartTime]
			,[EndTime])
		select 
			 @DocumentationsID
			,N'Путевая №' + @WaybillNumber
			,null
			,(select top 1 [ID] from [dbo].[DocumentationsClass] where [Description] = N'Путевая')
			,getdate()
			,getdate()
		
		--- insert Waybill properties
		insert into [dbo].[DocumentationsProperty]
			([Description]
			,[Value]
			,[ValueUnitofMeasure]
			,[DocumentationsProperty]
			,[DocumentationsClassPropertyID]
			,[DocumentationsID]
			,[ValueTime])		
		select
			 DCP.Description
			,T1.Value	as [Value]
			,null		as [ValueUnitofMeasure]
			,null		as [DocumentationsProperty]
			,DCP.ID		as [DocumentationsClassPropertyID]
			,1111		as [DocumentationsID]
			,getdate()	as [ValueTime]
		from (
		values
			 (N'Номер путевой',										cast(@WaybillNumber as nvarchar))
			,(N'Приемосдатчик',										cast(@Consigner as nvarchar))
			,(N'Род вагона',										cast(@WagonType as nvarchar))
			,(N'Род груза',											cast(@CargoType as nvarchar))
			,(N'Цех отправления',									cast(@SenderShop as nvarchar))
			,(N'Место погрузки',									cast(@SenderDistrict as nvarchar))
			,(N'Станция отправления',								cast(@SenderRWStation as nvarchar))
			,(N'Время прибытия (станция отправления)',				cast(@SenderArriveDT as nvarchar))
			,(N'Время подачи под погрузку (станция отправления)',	cast(@SenderStartLoadDT as nvarchar))
			,(N'Время окончания выгрузки (станция отправления)',	cast(@SenderEndLoadDT as nvarchar))
			,(N'Цех получения',										cast(@ReceiverShop as nvarchar))
			,(N'Место выгрузки',									cast(@ReceiverDistrict as nvarchar))
			,(N'Станция назначения',								cast(@ReceiverRWStation as nvarchar))
			,(N'Время прибытия (станция назначения)',				cast(@ReceiverArriveDT as nvarchar))
			,(N'Время подачи под погрузку (станция назначения)',	cast(@ReceiverStartLoadDT as nvarchar))
			,(N'Время окончания выгрузки (станция назначения)',		cast(@ReceiverEndLoadDT as nvarchar))
		) as T1([Property], [Value])		
		inner join [dbo].[DocumentationsClassProperty] DCP
		on T1.[Property] = DCP.[Description]

		--- insert Waybill wagon info 
		insert into [dbo].[PackagingUnitsDocs]
           ([Description]
           ,[DocumentationsID]
           ,[PackagingUnitsID]
           ,[Status]
           ,[StartTime])
		select
			 (select top 1 [Description] from [dbo].[PackagingUnits] where [ID] = @WagonNumber)
			,@DocumentationsID
			,@WagonNumber
			,null
			,getdate()
			

	COMMIT TRANSACTION  ins_SaveWaybill; 
	END TRY
		
	BEGIN CATCH
		ROLLBACK TRANSACTION ins_SaveWaybill;
		THROW 16,'Error transaction ins_SaveWaybill',1;	
	END CATCH


END




GO