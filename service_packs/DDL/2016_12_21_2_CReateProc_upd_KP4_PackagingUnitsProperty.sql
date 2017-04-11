USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_KP4_PackagingUnitsProperty',N'P') IS NOT NULL
  DROP PROCEDURE dbo.upd_KP4_PackagingUnitsProperty;
GO



/****** Object:  StoredProcedure [dbo].[upd_KP4_PackagingUnitsProperty]    Script Date: 31.10.2016 16:43:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


------ get information 'weight tare' from KRR-FAS71
CREATE PROCEDURE [dbo].[upd_KP4_PackagingUnitsProperty]

AS
BEGIN

 DECLARE  @maxDT_F71 datetime,  @maxDT_ISA datetime
 DECLARE  @N_CAR varchar(7), @WEIGHT_CAR real, @TIME_TARA datetime,
		  @ID_PackagingUnits int,
		  @ID_PackagingUnitsProperty int


    SELECT @maxDT_F71=max(TIME_TARA) FROM [KRR-FAS71].[LOMSRV].[dbo].[WEIGHT_TARA_ALL] 
    SELECT @maxDT_ISA=max(ValueTime) FROM  [dbo].[PackagingUnitsProperty] WHERE [Description]=N'Вес тары' 

 	IF @maxDT_F71>@maxDT_ISA
	BEGIN  

			DECLARE  selTaraFAS71 CURSOR
			FOR SELECT [N_CAR],[WEIGHT_CAR],[TIME_TARA]
				FROM [KRR-FAS71].[LOMSRV].[dbo].[WEIGHT_TARA_ALL] 
				WHERE [TIME_TARA]>@maxDT_ISA
				ORDER BY [TIME_TARA]

			OPEN selTaraFAS71;
			FETCH NEXT FROM selTaraFAS71 INTO @N_CAR, @WEIGHT_CAR, @TIME_TARA;
			WHILE @@FETCH_STATUS = 0
			BEGIN

				BEGIN TRY
                     -----  ID for wagon
	                 IF NOT EXISTS (SELECT ID FROM [PackagingUnits] WHERE [Description]=RTrim(@N_CAR))
	                 BEGIN
	                      SELECT  @ID_PackagingUnits=NEXT  VALUE FOR [dbo].[gen_PackagingUnits];
                          INSERT INTO [dbo].[PackagingUnits] ([ID],[Description],[Status],[Location]) 
			              VALUES( @ID_PackagingUnits, RTrim(@N_CAR), null, 1 )

	                 END
	                 ELSE
                     SELECT  @ID_PackagingUnits=ID FROM [dbo].[PackagingUnits] where [Description]=RTrim(@N_CAR)

	                 ------- Modify  Last Tara 
	                 IF NOT EXISTS (SELECT * FROM PackagingUnitsProperty WHERE [PackagingUnitsID]=@ID_PackagingUnits )
	                 BEGIN
			               SELECT @ID_PackagingUnitsProperty=(NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]);
                           INSERT INTO [dbo].[PackagingUnitsProperty]   (ID, [Description], [Value], ValueTime, [PackagingUnitsID])
                           VALUES (@ID_PackagingUnitsProperty,  N'Вес тары', cast(@WEIGHT_CAR as nvarchar), @TIME_TARA, @ID_PackagingUnits)  
			                     --- ((NEXT  VALUE FOR [dbo].[gen_PackagingUnitsProperty]),  N'Время тарирования', convert(nvarchar(max), @TIME_TARA,120), 3, @ID_PackagingUnitsProperty, @ID_PackagingUnits)

						   --print 'new '
						   --print @N_CAR
						   --print @WEIGHT_CAR
						   --print @TIME_TARA
                     END
	                 ELSE
	                 BEGIN
	                       UPDATE [dbo].[PackagingUnitsProperty]
	                       SET [Value]=cast(@WEIGHT_CAR as nvarchar), ValueTime=@TIME_TARA
	                       WHERE [PackagingUnitsID]=@ID_PackagingUnits  and [Description]=N'Вес тары';

	                       --UPDATE [dbo].[PackagingUnitsProperty]
	                       --SET [Value]=convert(nvarchar(max), @TIME_TARA,120)
	                       --WHERE [PackagingUnitsID]=@ID_PackagingUnits and [PackagingDefinitionPropertyID]=3;
                     END

				END TRY
				BEGIN CATCH

                     INSERT INTO [dbo].[ErrorLog](error_details,error_message )
                     SELECT  N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) 
		                     + N', ERROR_SEVERITY: '+ IsNull(CAST(ERROR_SEVERITY() AS NVARCHAR),N'')
 			                 + N', PROCEDURE: upd_KP4_PackagingUnitsProperty'
			                 + N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
                             ERROR_MESSAGE();
				END CATCH;

				FETCH NEXT FROM selTaraFAS71 INTO @N_CAR, @WEIGHT_CAR, @TIME_TARA;
			END;
			CLOSE selTaraFAS71;
			DEALLOCATE selTaraFAS71;

            INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], DispatchStatus,  [Command], CommandRule)
            VALUES ((NEXT  VALUE FOR [dbo].[gen_JobOrder]), 'KP4_GetTara', CURRENT_TIMESTAMP, N'Done', 'upd_PackagingUnitsProperty', '[KRR-FAS71]');

	END

	 
END