SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.exec_KP4_LOMExport',N'P') IS NOT NULL
  DROP PROCEDURE [dbo].[exec_KP4_LOMExport]

GO

-- exec procedure from JOB
-- =============================================
CREATE PROCEDURE [dbo].[exec_KP4_LOMExport]
AS
BEGIN

  DECLARE @ID_JobResp int, @ID_JobOrder int

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

            SELECT   top 50
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
                (SELECT top 1 CAST(Value as float) FROM   dbo.PackagingUnitsProperty WHERE	PackagingDefinitionPropertyID=2	AND PackagingUnitsID = dbo.PackagingUnits.ID) AS Tare, 
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

        EXEC [dbo].[ins_ErrorLog];

      --   INSERT INTO [dbo].[ErrorLog](error_details,error_message )
      --   SELECT  N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) 
		    --   + N', ERROR_SEVERITY: '+ IsNull(CAST(ERROR_SEVERITY() AS NVARCHAR),N'')
			   --+ N', ERROR_STATE: '+ IsNull(CAST(ERROR_STATE() AS NVARCHAR),N'') 
			   --+ N', ERROR_PROCEDURE: '+ IsNull(ERROR_PROCEDURE(),N'') 
			   --+ N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
      --       ERROR_MESSAGE();

   END CATCH;


END;