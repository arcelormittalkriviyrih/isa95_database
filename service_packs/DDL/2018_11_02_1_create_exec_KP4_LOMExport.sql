IF OBJECT_ID ('dbo.exec_KP4_LOMExport',N'P') IS NOT NULL
  DROP PROCEDURE dbo.exec_KP4_LOMExport;
GO

/*
	Procedure: exec_KP4_LOMExport
	Процедура экспорта данных по взвешиванию на Копр-4 для ШО КЦ

	Parameters:

		null
		
*/
CREATE PROCEDURE [dbo].[exec_KP4_LOMExport]
AS
BEGIN

declare @maxDT_ISA datetime
declare @maxDT_FAS datetime

DECLARE @ID_JobOrder int,
        @DTtara datetime

-----------------------------------------------------------Information from weighting ------------------------------------------
  BEGIN TRY

	-- get max DT from destination table
	SELECT @maxDT_FAS = max([TIME_BRUTTO])
	FROM [KRR-FAS71].LOMSRV.[dbo].[copy_Lom_KP4]

	-- get max DT from source table
	SELECT top 1 @maxDT_ISA = WO.[OperationTime]
	FROM [dbo].[WeightingOperations] WO
	join [dbo].[Equipment] E
	on WO.[EquipmentID] = E.[ID]
	join [dbo].[Documentations] D
	on WO.[DocumentationsID] = D.[ID]
	where	WO.[OperationType] = N'Погрузка' 
		and WO.[Status] is null 
		and E.[Description] = N'Весы Копр.№4'
		and D.[Status] = N'closed'
	order by WO.[ID] desc

    if @maxDT_FAS < @maxDT_ISA	
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
               ,[dt_insert])

		SELECT
			 D.[ID]							as [ID_CAR]
			,vDP.[Value]					as [N_DOCUMENT]
			,D.[EndTime]					as [DATE_WORK]
			,substring(WO.[Description], 0, charindex('-', WO.[Description])) as [PLATFORM]
			,substring(WO.[Description], charindex('-', WO.[Description])+1, len(WO.[Description])) as [COROB]
			,vDP1.[Value2]					as [NAME_SUBDEPT]
			,MDP.[Value]					as [CODE_LOM_SAP]
			,WO.[MaterialDefinitionID]		as [CODE_LOM]
			,MD.[Description]				as [NAME_LOAD]
			,WO.[OperationTime]				as [TIME_BRUTTO]
			,WO.[Brutto]					as [BRUTTO]
			,WO.[Netto]						as [VES_LOM]
			,WO.[Tara]						as [TARA]
			,1								as [fl_Add]
			,WO.[ID]						as [ID_JobResponse]
			,getdate()						as [dt_insert]

		FROM [dbo].[WeightingOperations] WO
		join [dbo].[Equipment] E
		on WO.[EquipmentID] = E.[ID]
		join [dbo].[Documentations] D
		on WO.[DocumentationsID] = D.[ID]

		join [dbo].[v_WGT_DocumentsProperty] vDP
		on vDP.[DocumentationsID] = D.[ID] and vDP.[Description] = N'Номер отвесной'

		join [dbo].[MaterialDefinition] MD
		on WO.[MaterialDefinitionID] = MD.[ID]
		join [dbo].[MaterialDefinitionProperty] MDP
		on MDP.[MaterialDefinitionID] = MD.[ID] and MDP.[Description] = N'Вид лома'

		inner hash join [dbo].[PackagingUnitsDocsProperty] PUDP
		on WO.[PackagingUnitsDocsID] = PUDP.[PackagingUnitsDocsID] and PUDP.[Description] = N'Путевая'

		inner hash join [dbo].[v_WGT_DocumentsProperty] vDP1
		on PUDP.[Value] = vDP1.[DocumentationsID] and vDP1.[Description] = N'Место погрузки'
		inner hash join [dbo].[v_WGT_DocumentsProperty] vDP2
		on PUDP.[Value] = vDP2.[DocumentationsID] and vDP2.[Description] = N'Место выгрузки'

		where	WO.[OperationTime] > @maxDT_FAS
			and WO.[OperationType] = N'Погрузка' 
			and WO.[Status] is null
			and E.[Description] = N'Весы Копр.№4'
			and D.[Status] = N'closed'
			and vDP1.[Value2] in (N'Керамет-Украина Копр.№4')
			and vDP2.[Value2] in (N'Шихтовое отделение №1', N'Шихтовое отделение №2')
		order by WO.[ID]

		
        SET @ID_JobOrder=NEXT VALUE FOR [dbo].[gen_JobOrder];
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
GO