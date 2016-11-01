USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_KP4_WeightBrutto',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_KP4_WeightBrutto;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-------TRANSACTION insKP4_TakeWeight
CREATE PROCEDURE [dbo].[ins_KP4_WeightBrutto]
   @WorkPerformanceID int,					-- ID WeightSheet 
   @WagonNumber   nvarchar(50),             -- Number wagon
   @WorkResponseDescription  nvarchar(50),  -- Number waybill
   @Value    real,					        -- Weight 
   @WeightMode nvarchar(20),                -- Mode operation brutto\tara
   @MaterialDefinitionID int,                -- Code scrap (CSH)
   @ReceiverID int,            
   @SenderID int 
    
AS
BEGIN
 DECLARE @ID_JobResponse int,
         @ID_WorkResponse int, @fl_Dubl bit, @WeightFirst real,
		 @ID_JobOrder int,
		 @ID_OpMaterialActual int


     --------- Dubl weighting wagon
	 if exists(SELECT * FROM [dbo].[WorkResponse] WHERE [Description]=@WorkResponseDescription AND  [WorkType]=@WeightMode AND [WorkPerfomence]=@WorkPerformanceID)
	 BEGIN

	     SELECT @ID_WorkResponse=ID  
		 FROM   [dbo].[WorkResponse] 
		 WHERE  [Description]=@WorkResponseDescription AND  [WorkType]=@WeightMode AND [WorkPerfomence]=@WorkPerformanceID

		 SET @WeightFirst =	Isnull(  (SELECT Cast(map.Value as Float)
		                              FROM  (SELECT max(ID) as jrID FROM [dbo].[JobResponse] WHERE WorkResponse=@ID_WorkResponse ) jr
                                        left join [OpMaterialActual] oma on oma.JobResponseID=jr.jrID AND  oma.MaterialClassID=12
                                        left join [MaterialActualProperty] map on map.OpMaterialActual=oma.ID 
                                       ), 0)

		 --SET @WeightFirst =	Isnull(  (SELECT Cast(map.Value as Float)
		 --                             FROM  (SELECT max(ID) as jrID FROM [dbo].[JobResponse] WHERE WorkResponse=@ID_WorkResponse ) jr
   --                                     left join [OpMaterialActual] oma on oma.JobResponseID=jr.jrID
   --                                     left join [MaterialActualProperty] map on map.OpMaterialActual=oma.ID 
   --                                   WHERE  map.Description='Weight brutto' ), 0)
		 SET @fl_Dubl=1;
	 END

	 ELSE   --------- First weighting wagon
	 BEGIN
         SET @ID_WorkResponse=NEXT VALUE FOR [dbo].[gen_WorkResponse];

		 SET @WeightFirst =	Isnull((SELECT Cast(pap.Value as Float) 
		                            FROM   dbo.PackagingUnitsProperty pap right join dbo.PackagingUnits pu
									       on pu.ID=pap.PackagingUnitsID and pap.PackagingDefinitionPropertyID=2
	                                WHERE  pu.[Description]=@WagonNumber),   50);
		 SET @fl_Dubl=0;

		 --SET @WeightFirst =	Isnull( ( SELECT Cast(Value as Float) 
		 --     FROM  ( SELECT ID FROM [dbo].[PhysicalAsset]  WHERE [Description]=@WagonNumber ) pa
		 -- left join  [dbo].[PhysicalAssetProperty] pap on pap.PhysicalAssetID=pa.ID WHERE [Description] like N'Weight tare %'),  50);  

	 END

     SET @ID_JobOrder=NEXT     VALUE FOR [dbo].[gen_JobOrder];
     INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [DispatchStatus], [Command])
     VALUES (@ID_JobOrder, @WeightMode, CURRENT_TIMESTAMP,'Done', 'ins_KP4_WeightBrutto');

     ----  New waybill for wagon
	 IF @fl_Dubl=0
         INSERT INTO [dbo].[WorkResponse]     ([ID], [Description],  [WorkType], [StartTime], [EndTime], [WorkPerfomence] ) 
         VALUES    (@ID_WorkResponse, @WorkResponseDescription,  @WeightMode, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @WorkPerformanceID )

     ---- New operation weighting
     SET @ID_JobResponse=NEXT  VALUE FOR [dbo].[gen_JobResponse];
     INSERT INTO [dbo].[JobResponse]      ([ID], [Description], [WorkType], [JobOrderID],  [StartTime], [EndTime], [WorkResponse] )
     VALUES 	   (@ID_JobResponse, N'Operation weighting', @WeightMode, @ID_JobOrder, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @ID_WorkResponse )

     ---- Code material scrap (CSH)
     INSERT INTO [dbo].[OpMaterialActual]                         --  ID autoincrement
        ([MaterialDefinitionID] ,[MaterialLotID]  ,[Description]  ,[JobResponseID]    ,[MaterialClassID]) 
     SELECT  @MaterialDefinitionID, 3236,  [Description],  @ID_JobResponse, ID 
	 FROM  [dbo].[MaterialClass] WHERE ID between 9 and 14 ORDER BY ID

     SELECT @ID_OpMaterialActual=@@IDENTITY

---     VALUES	    (@MaterialDefinitionID, 3236, N'CSH LOM', @ID_JobResponse,  9),   
--ВидЛома
--Вес нетто Дебет 10
--Вес нетто Кредит 11
--Вес брутто 12
--Отправитель 13
--Получатель 14

     INSERT INTO [dbo].[MaterialActualProperty]   ([Description],[OpMaterialActual],[Value])
	 SELECT [Description],ID,
	        (CASE WHEN MaterialClassID=9  THEN   [MaterialDefinitionID]
			      WHEN MaterialClassID=10 THEN   @Value-@WeightFirst
			      WHEN MaterialClassID=11 THEN   ( @Value-@WeightFirst) * (-1)
                  WHEN MaterialClassID=12 THEN   @Value
                  WHEN MaterialClassID=13 THEN   @SenderID
			      WHEN MaterialClassID=14 THEN   @ReceiverID
				  ELSE 'error' END)
	 FROM [dbo].[OpMaterialActual] 
	 WHERE ID between (@ID_OpMaterialActual-5) and  (@ID_OpMaterialActual)


	 --VALUES	 ( N'Weight brutto',  @Value,   @ID_OpMaterialActual   ),              ---- New Brutto
	 --        ( N'Weight netto',   @Value-@WeightFirst,   @ID_OpMaterialActual   )  ---- Calculate Netto 


     -- Mode new-operation for wagon  ----------- зачем??????????????????
     INSERT INTO [dbo].[OpPackagingActual]     ([Description]       ,[PackagingUnitsID]          ,[JobResponseID])
	 SELECT top 1 
	        -------isnull((SELECT max(ID) FROM  [dbo].[OpPackagingActual]),0) + 1,     ---- !!!!!!!!!!!!! NOT defined ID
			@WeightMode, 
			ID, 
			@ID_JobResponse
	 FROM   [dbo].[PackagingUnits]
	 WHERE  [Description]=@WagonNumber


    ----- Sender AND REciever
    INSERT INTO [dbo].[OpEquipmentActual]      ([EquipmentID], [Description], [JobResponseID], [EquipmentClassID], Quantity)
    SELECT ID,[Description], @ID_JobResponse, 16, 0
    FROM Equipment 	WHERE ID=@ReceiverID

    INSERT INTO [dbo].[OpEquipmentActual]      ([EquipmentID], [Description], [JobResponseID], [EquipmentClassID], Quantity)
    SELECT ID,[Description], @ID_JobResponse, 15, 0
    FROM Equipment 	WHERE ID=@SenderID




END