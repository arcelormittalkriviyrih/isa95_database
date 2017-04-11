-- exec procedure from JOB
-- =============================================
ALTER PROCEDURE [dbo].[exec_KP4_LOMExport]
AS
BEGIN

  DECLARE @ID_JobResp int, @ID_JobOrder int,
          @DTtara datetime

-----------------------------------------------------------Information from weighting ------------------------------------------
  BEGIN TRY

    SELECT @ID_JobResp=max([ID_JobResponse]) 
	FROM [KRR-FAS71].LOMSRV.[dbo].[copy_Lom_KP4]

	IF @ID_JobResp<(SELECT max(JobResponse.ID)  
	                FROM  JobResponse 
					     INNER JOIN WorkResponse    ON JobResponse.WorkResponse = WorkResponse.ID 
						 INNER JOIN WorkPerformance ON WorkResponse.WorkPerfomence = WorkPerformance.ID 
	                WHERE JobResponse.WorkType='Weighting' AND JobResponse.JobState is NULL   AND WorkPerformance.WorkState='Closed')
    BEGIN
        INSERT INTO [KRR-FAS71].LOMSRV.[dbo].[copy_Lom_KP4]
               ([ID_CAR]
               ,[N_DOCUMENT]
               ,[DATE_WORK]
               ,[PLATFORM]
               ,[COROB]
               ,[NAME_SUBDEPT]
               ,[CODE_LOM_SAP]
               ,[CODE_LOM]
               ,[NAME_LOAD]
               ,[TIME_BRUTTO]
               ,[BRUTTO]
               ,[VES_LOM]
               ,[TARA]
               ,[fl_Add]
               ,[ID_JobResponse]
               ,[dt_insert]
			   )

            SELECT   
            	WorkResponse.ID as ID_CAR, 
            	WorkPerformance.Description AS N_DOC, 
            	CAST(WorkPerformance.[EndTime] as DateTime) AS DATE_WORK,
            	-----PackagingUnits.Description		AS WagonNumber,  
                substring(PackagingUnits.Description, 0, charindex('-', PackagingUnits.Description)) AS PLATF, 
                substring(PackagingUnits.Description, charindex('-', PackagingUnits.Description)+1, LEN(PackagingUnits.Description)-charindex('-', PackagingUnits.Description)) AS COROB, 
            	(select top 1 [Description] from dbo.Equipment where ID = map.sndr)  COLLATE  Ukrainian_CI_AS AS NAME_SUBDEPT,   ---	N'Копр.отд. №4',
            	140000000+map.CSH AS  CODE_LOM_SAP,
            	CAST(map.CSH as int) AS CODE_LOM, 
            	CAST(MaterialDefinition.Description	AS nvarchar(25))  COLLATE  Ukrainian_CI_AS AS NAME_LOM, 
            	CAST(JobResponse.StartTime as DateTime) AS WeightingTime,
            	map.brutto, 
            	map.netto, 
                (SELECT top 1 CAST(Value as float) FROM   dbo.PackagingUnitsProperty WHERE  PackagingUnitsID=dbo.PackagingUnits.ID and [Description]=N'Вес тары' ) AS Tare, 
				(ROW_NUMBER() over (partition by dbo.WorkPerformance.ID, dbo.WorkResponse.ID order by map.netto))  AS fl_Add,
            	JobResponse.ID,
            	getdate() dti
            
            FROM
            	dbo.JobResponse INNER JOIN
            	dbo.WorkResponse ON dbo.JobResponse.WorkResponse = dbo.WorkResponse.ID INNER JOIN
            	dbo.WorkPerformance ON dbo.WorkResponse.WorkPerfomence = dbo.WorkPerformance.ID LEFT OUTER JOIN
            	dbo.OpPackagingActual ON dbo.JobResponse.ID = dbo.OpPackagingActual.JobResponseID LEFT OUTER JOIN
            	dbo.PackagingUnits ON dbo.OpPackagingActual.PackagingUnitsID = dbo.PackagingUnits.ID LEFT OUTER JOIN
            
            	dbo.OpMaterialActual om ON dbo.JobResponse.ID = om.JobResponseID  AND om.MaterialClassID=9 LEFT OUTER JOIN
            	 dbo.MaterialDefinition ON dbo.MaterialDefinition.ID= om.MaterialDefinitionID  LEFT OUTER JOIN
                (   SELECT   OpMaterialActual, CAST(MAX([Вид лома]) as int) CSH, 
                           CAST(MAX([Вес брутто]) as real)  brutto,  CAST(MAX([Вес нетто Дебет]) as real) netto,
            		       CAST(MAX([Получатель]) as int) rcvr,  CAST(MAX([Отправитель]) as int)  sndr
			        FROM  dbo.MaterialActualProperty 
                    PIVOT (MAX(Value) FOR  [Description] in  ([Вид лома], [Вес брутто], [Вес нетто Дебет], [Получатель], [Отправитель]) ) AS pvt   
                    GROUP BY OpMaterialActual ) map  
            	 ON map.OpMaterialActual=om.ID  
            
            WHERE JobResponse.WorkType='Weighting' AND JobResponse.JobState is NULL
                  AND WorkPerformance.WorkState='Closed'
            	  AND PackagingUnits.Description is NOT NULL
            	  AND JobResponse.ID> @ID_JobResp
            ORDER BY ID
            
            SET @ID_JobOrder=NEXT  VALUE FOR [dbo].[gen_JobOrder];
            INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], DispatchStatus,  [Command], CommandRule)
            VALUES (@ID_JobOrder, 'KP4_LOMExport', CURRENT_TIMESTAMP, N'Done', 'Send', '[KRR-FAS71]');

   END
        
   END TRY
   BEGIN CATCH
         INSERT INTO [dbo].[ErrorLog](error_details,error_message )
         SELECT  N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) 
			   + N', ERROR_PROCEDURE: exec_KP4_LOMExport(weight)'
			   + N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
             ERROR_MESSAGE();
   END CATCH;

-----------------------------------------------------------Information from taring ------------------------------------------

  BEGIN TRY

    SELECT @DTtara=max(TIME_TARA) 
	FROM [KRR-FAS71].LOMSRV.[dbo].WEIGHT_TARA_ALL


 --   SELECT * FROM [KRR-FAS71].LOMSRV.[dbo].WEIGHT_TARA_ALL WHERE TIME_TARA>@DTtara

	IF @DTtara<(SELECT max(ValueTime) FROM  PackagingUnitsProperty)
    BEGIN

		     UPDATE [KRR-FAS71].LOMSRV.[dbo].WEIGHT_TARA_ALL
			 SET    WEIGHT_CAR= cast(pr2.Value as real),
			        TIME_TARA =  pr2.ValueTime,
					PackagingUnitsID=pu.ID
		     FROM   dbo.PackagingUnitsProperty pr2 
		            left join dbo.PackagingUnits pu on pr2.PackagingUnitsID=pu.ID
					left join [KRR-FAS71].LOMSRV.[dbo].WEIGHT_TARA_ALL tara71  on tara71.N_CAR=pu.Description COLLATE Ukrainian_CI_AS
		     WHERE  pr2.ValueTime>@DTtara

             SET @ID_JobOrder=NEXT  VALUE FOR [dbo].[gen_JobOrder];
             INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], DispatchStatus,  [Command], CommandRule)
             VALUES (@ID_JobOrder, 'KP4_LOMExport', CURRENT_TIMESTAMP, N'Done', 'Send tara', '[KRR-FAS71]');

    END            
   END TRY
   BEGIN CATCH
         INSERT INTO [dbo].[ErrorLog](error_details,error_message )
         SELECT  N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) 
			   + N', ERROR_PROCEDURE: exec_KP4_LOMExport(tara)'
			   + N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
             ERROR_MESSAGE();
   END CATCH;

END;