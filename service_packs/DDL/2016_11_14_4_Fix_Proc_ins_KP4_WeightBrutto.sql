USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_KP4_WeightBrutto',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_KP4_WeightBrutto;
GO
 
SET ANSI_NULLS ON
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
   @SenderID int, 
   @WeightBridgeID    int                    --  ID Equipment
    
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
                                        left join [OpMaterialActual] oma on oma.JobResponseID=jr.jrID AND  oma.MaterialClassID=9
                                        left join (SELECT * FROM [MaterialActualProperty] WHERE [Description]=N'Вес брутто') map 
										on map.OpMaterialActual=oma.ID 
                                       ), 0)
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
     SELECT top 1  @MaterialDefinitionID, isnull(lo.ID,3236),  cl.[Description],  @ID_JobResponse, cl.ID 
	 FROM  [dbo].[MaterialClass] cl left join 
	       [dbo].[MaterialLot]   lo  on lo.FactoryNumber = cast(@WorkPerformanceID as nvarchar) 
	 WHERE cl.ID=9 

     SELECT @ID_OpMaterialActual=@@IDENTITY

     INSERT INTO [dbo].[MaterialActualProperty]   ([Description],[OpMaterialActual],[Value])
	 SELECT mcp.[Description], oma.ID,
	        (CASE WHEN mcp.Value=N'Scrap type'   THEN   @MaterialDefinitionID
			      WHEN mcp.Value=N'Netto debit'  THEN   @Value-@WeightFirst
			      WHEN mcp.Value=N'Netto credit' THEN   ( @Value-@WeightFirst) * (-1)
                  WHEN mcp.Value=N'Brutto'   THEN   @Value
                  WHEN mcp.Value=N'Sender'   THEN   @SenderID
			      WHEN mcp.Value=N'Receiver' THEN   @ReceiverID
				  ELSE 'error' END) value
	 FROM MaterialClassProperty mcp,
	      OpMaterialActual oma   
	 WHERE mcp.MaterialClassID=9  and   oma.ID=@ID_OpMaterialActual

     -- Mode new-operation for wagon  
     INSERT INTO [dbo].[OpPackagingActual]     ([Description]       ,[PackagingUnitsID]          ,[JobResponseID])
	 SELECT top 1 
			@WeightMode, 
			ID, 
			@ID_JobResponse
	 FROM   [dbo].[PackagingUnits]
	 WHERE  [Description]=@WagonNumber



    ----------------  Equipment
    INSERT INTO [dbo].[OpEquipmentActual]      ([EquipmentID], [Description], [JobResponseID], [EquipmentClassID], Quantity)
    SELECT ID,[Description], @ID_JobResponse, [EquipmentClassID], 0
    FROM Equipment 	WHERE ID=@WeightBridgeID

    ----- Sender AND REciever
    --INSERT INTO [dbo].[OpEquipmentActual]      ([EquipmentID], [Description], [JobResponseID], [EquipmentClassID], Quantity)
    --SELECT ID,[Description], @ID_JobResponse, [EquipmentClassID], 0
    --FROM Equipment 	WHERE ID=@ReceiverID

    --INSERT INTO [dbo].[OpEquipmentActual]      ([EquipmentID], [Description], [JobResponseID], [EquipmentClassID], Quantity)
    --SELECT ID,[Description], @ID_JobResponse, [EquipmentClassID], 0
    --FROM Equipment 	WHERE ID=@SenderID

	
	/*== test OpPersonnelActual ==*/
	
	insert into [dbo].[OpPersonnelActual] (
		 [PersonID]
		,[Description]
		,[Quantity]
		,[JobResponseID]
		,[PersonnelClassID])
	select top 1 
		p.ID,
		p.PersonName,
		1,
		@ID_JobResponse		[JobResponseID],
		p.PersonnelClassID
	from [dbo].[Person] p
	where ID = [dbo].[get_CurrentPerson]()


END

GO

