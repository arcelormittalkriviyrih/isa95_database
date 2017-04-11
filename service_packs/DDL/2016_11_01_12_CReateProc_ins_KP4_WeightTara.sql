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
     VALUES (@ID_JobOrder, @WeightMode, @DT,'Done', 'ins_KP4_WeightTara');
  

     ----  New waybill for wagon
	 SET @ID_WorkResponse=NEXT VALUE FOR [dbo].[gen_WorkResponse];
     INSERT INTO [dbo].[WorkResponse]     ([ID], [Description], [WorkType],  [StartTime], [EndTime], [WorkPerfomence] ) 
     VALUES       (@ID_WorkResponse, @WorkResponseDescription,  @WeightMode, @DT, CURRENT_TIMESTAMP, @WorkPerformanceID )

     ---- New operation weighting
	 SET @ID_JobResponse=NEXT  VALUE FOR [dbo].[gen_JobResponse];
     INSERT INTO [dbo].[JobResponse]      ([ID], [Description], [WorkType], [JobOrderID],  [StartTime], [EndTime], [WorkResponse] )
     VALUES 	   (@ID_JobResponse, N'Operation weighting', @WeightMode, @ID_JobOrder, @DT, CURRENT_TIMESTAMP, @ID_WorkResponse )

     -----  ID for wagon
	 if not exists (SELECT * FROM [PackagingUnits] WHERE [Description]=@WagonNumber )
	 BEGIN
	        SELECT  @ID_PackagingUnits=NEXT  VALUE FOR [dbo].[gen_PackagingUnits];
            INSERT INTO [dbo].[PackagingUnits] ([ID],[Description],[Status],[Location]) 
			VALUES( @ID_PackagingUnits, @WagonNumber, null, 1 )
	 END
	 ELSE
            SELECT  @ID_PackagingUnits=ID FROM  [dbo].[PackagingUnits] where [Description]=@WagonNumber

	 ------- Modify  Last Tara (weight and DT)

	 if not exists (SELECT * FROM PackagingUnitsProperty WHERE [PackagingUnitsID]=@ID_PackagingUnits )
	 BEGIN
			SELECT @ID_PackagingUnitsProperty=(NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]);
            INSERT INTO [dbo].[PackagingUnitsProperty]     
			       (ID, [Description], [Value], ValueTime, [PackagingUnitsProperty], [PackagingUnitsID])
            VALUES (@ID_PackagingUnitsProperty,  N'Вес тары', cast(@Value as nvarchar), @DT, @ID_PackagingUnitsProperty, @ID_PackagingUnits)
			       ----((NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]),  N'Время тарирования', convert(nvarchar(max), @DT,120), 3, @ID_PackagingUnitsProperty, @ID_PackagingUnits)
     END
	 ELSE
	 BEGIN
	        UPDATE [dbo].[PackagingUnitsProperty]
	        SET [Value]=cast(@Value as nvarchar),
			     ValueTime=@DT
	        WHERE [PackagingUnitsID]=@ID_PackagingUnits and [Description]=N'Вес тары'   ----[PackagingDefinitionPropertyID]=2

	        --UPDATE [dbo].[PackagingUnitsProperty]
	        --SET [Value]=convert(nvarchar(max), @DT,120)
	        --WHERE [PackagingUnitsID]=@ID_PackagingUnits and [PackagingDefinitionPropertyID]=3
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
