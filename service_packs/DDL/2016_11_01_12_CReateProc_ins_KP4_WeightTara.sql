USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_KP4_WeightTara',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_KP4_WeightTara;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	
------TRANSACTION insKP4_TakeWeight
CREATE PROCEDURE [dbo].[ins_KP4_WeightTara]
   @WorkPerformanceID int,					-- ID WeightSheet 
   @WagonNumber   nvarchar(50),             -- Number wagon
   @WorkResponseDescription  nvarchar(50),  -- Number waybill
   @Value    real,					        -- Weight tara
   @WeightMode nvarchar(20)                 -- Mode operation brutto\tara

AS
BEGIN
 DECLARE @ID_JobResponse int,
         @ID_WorkResponse int,
		 @ID_OpPackagingActual int,
	---	 @ID_OpPackagingActualProperty int,
		 @ID_PackagingUnits int,
		 @ID_PackagingUnitsProperty int,
		 @ID_JobOrder int,
		 @DT datetime

     SET @DT=getdate()
		
     SET @ID_JobOrder=NEXT     VALUE FOR [dbo].[gen_JobOrder];
     INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [DispatchStatus], [Command])
     VALUES (@ID_JobOrder, @WeightMode, CURRENT_TIMESTAMP,'Done', 'ins_KP4_WeightTara');
  

     ----  New waybill for wagon
	 SET @ID_WorkResponse=NEXT VALUE FOR [dbo].[gen_WorkResponse];
     INSERT INTO [dbo].[WorkResponse]     ([ID], [Description], [WorkType],  [StartTime], [EndTime], [WorkPerfomence] ) 
     VALUES       (@ID_WorkResponse, @WorkResponseDescription,  @WeightMode, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @WorkPerformanceID )

     ---- New operation weighting
	 SET @ID_JobResponse=NEXT  VALUE FOR [dbo].[gen_JobResponse];
     INSERT INTO [dbo].[JobResponse]      ([ID], [Description], [WorkType], [JobOrderID],  [StartTime], [EndTime], [WorkResponse] )
     VALUES 	   (@ID_JobResponse, N'Operation weighting', @WeightMode, @ID_JobOrder, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @ID_WorkResponse )

     -----  ID for wagon
	 if not exists (SELECT * FROM [PackagingUnits] WHERE [Description]=@WagonNumber )
	 BEGIN
	        SELECT  @ID_PackagingUnits=NEXT  VALUE FOR [dbo].[gen_PackagingUnits];
            INSERT INTO [dbo].[PackagingUnits] ([ID],[Description],[Status],[PackagingDefinitionID],[Location]) 
			VALUES( @ID_PackagingUnits, @WagonNumber, null, 1, 1 )
	 END
	 ELSE
            SELECT  @ID_PackagingUnits=ID FROM  [dbo].[PackagingUnits] where [Description]=@WagonNumber

	 ------- Modify  Last Tara (weight and DT)

	 if not exists (SELECT * FROM PackagingUnitsProperty WHERE [PackagingUnitsID]=@ID_PackagingUnits )
	 BEGIN
			SELECT @ID_PackagingUnitsProperty=(NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]);
            INSERT INTO [dbo].[PackagingUnitsProperty]     
			       (ID, [Description], [Value], [PackagingDefinitionPropertyID], [PackagingUnitsProperty], [PackagingUnitsID])
            VALUES (@ID_PackagingUnitsProperty,  N'Тара', NULL, 1, 0, @ID_PackagingUnits),
			       ((NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]),  N'Вес тары',          cast(@Value as nvarchar),              2, @ID_PackagingUnitsProperty, @ID_PackagingUnits),
			       ((NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]),  N'Время тарирования', convert(nvarchar(max), getdate(),120), 3, @ID_PackagingUnitsProperty, @ID_PackagingUnits)
     END
	 ELSE
	 BEGIN
	        UPDATE [dbo].[PackagingUnitsProperty]
	        SET [Value]=cast(@Value as nvarchar)
	        WHERE [PackagingUnitsID]=@ID_PackagingUnits and [PackagingDefinitionPropertyID]=2

	        UPDATE [dbo].[PackagingUnitsProperty]
	        SET [Value]=convert(nvarchar(max), getdate(),120)
	        WHERE [PackagingUnitsID]=@ID_PackagingUnits and [PackagingDefinitionPropertyID]=3
	 END

	 ------ Add Tara to archive

     -- Mode new-operation for wagon
	 SELECT  @ID_OpPackagingActual=(NEXT  VALUE FOR [dbo].[gen_OpPackagingActual]);

	 INSERT INTO [dbo].[OpPackagingActual]
           ([ID]
           ,[Description]
           ,[PackagingUnitsID] 
           ,[JobResponseID])
	 SELECT top 1 
	        @ID_OpPackagingActual,    
			@WeightMode, 
			ID, 
			@ID_JobResponse
	 FROM   [dbo].[PackagingUnits]
	 WHERE  [Description]=@WagonNumber

	 ---- Add Tara to archive
	--- SELECT @ID_OpPackagingActualProperty=max(ID)+1 FROM  [dbo].[OpPackagingActualProperty] 
	 INSERT INTO [dbo].[OpPackagingActualProperty]       ( [Description], [Value], [OpPackagingActualID]   )
	 VALUES 	   (N'Weight tara', cast(@Value as nvarchar),@ID_OpPackagingActual)
	
 
      -----  ID for wagon
	 ---SELECT  @ID_PhysicalAsset=ID   FROM  [dbo].[PhysicalAsset]  WHERE [Description]=@WagonNumber 	  		

	 ------- Modify  Last Tara (weight and DT)

	 --if not exists (SELECT * FROM [dbo].[PhysicalAssetProperty] WHERE [PhysicalAssetID]=@ID_PhysicalAsset AND [Description] like N'Weight tare %')
  --          INSERT INTO [dbo].[PhysicalAssetProperty]      ([Description], [Value], [PhysicalAssetID])
  --          VALUES ( N'Weight tare '+@WagonNumber, cast(@Value as nvarchar),  @ID_PhysicalAsset)
	 --ELSE
	 --       UPDATE [dbo].[PhysicalAssetProperty]
		--	SET    [Description]= N'Weight tare '+@WagonNumber, 
		--	       [Value] = cast(@Value as nvarchar)
		--	WHERE  [PhysicalAssetID]=@ID_PhysicalAsset AND [Description] like N'Weight tare %'

	 --if not exists (SELECT * FROM [dbo].[PhysicalAssetProperty] WHERE [PhysicalAssetID]=@ID_PhysicalAsset AND [Description] like N'Weighing time %')
  --          INSERT INTO [dbo].[PhysicalAssetProperty]      ( [Description], [Value], [PhysicalAssetID])
  --          VALUES ( N'Weighing time '+@WagonNumber, convert(nvarchar(max), @DT, 120),  @ID_PhysicalAsset)
	 --ELSE
	 --       UPDATE [dbo].[PhysicalAssetProperty]
		--	SET    [Description]= N'Weighing time '+@WagonNumber, 
		--	       [Value] = convert(nvarchar(max), @DT, 120)
		--	WHERE  [PhysicalAssetID]=@ID_PhysicalAsset AND [Description] like N'Weighing time %'

	 ------ Add Tara to archive

	 --SET @ID_OpPhysicalAssetActual=NEXT  VALUE FOR [dbo].[gen_OpPhysicalAssetActual];
  --   INSERT INTO [dbo].[OpPhysicalAssetActual]       ([ID]    ,[PhysicalAssetID]     ,[Description]      ,[JobResponseID]       ,[PhysicalAssetClassID])
  --   VALUES (@ID_OpPhysicalAssetActual,   @ID_PhysicalAsset, @WagonNumber,   @ID_JobResponse, 543)


  --   INSERT INTO [dbo].[PhysicalAssetActualProperty]        ([Description], [Value], [OpPhysicalAssetActual])
  --   VALUES (N'Weighing time',           convert(nvarchar(max), @DT, 120), @ID_OpPhysicalAssetActual),
  --          (N'LafetScrapBox',              @WagonNumber,             @ID_OpPhysicalAssetActual),
  --          (N'Tare', cast(@Value as nvarchar), @ID_OpPhysicalAssetActual)	
    
  
END


