
ALTER VIEW [dbo].[v_KP4_Wagon]
AS
SELECT     TOP (100) PERCENT 
	dbo.JobResponse.ID, 
	dbo.WorkPerformance.ID				AS WorkPerformanceID, 
	dbo.WorkPerformance.Description		AS WeightSheetNumber, 
	dbo.WorkResponse.ID					AS WorkResponseID, 
	dbo.PackagingUnits.ID				AS PackagingUnitsID, 
	dbo.PackagingUnits.Description		AS WagonNumber, 
	dbo.WorkResponse.Description		AS WaybillNumber, 
	dbo.JobResponse.WorkType, 
	dbo.MaterialDefinition.ID			AS MaterialDefinitionID, 
	dbo.MaterialDefinition.Description	AS Group_Lom, 
	om.ID				AS OpMaterialActualID, 
	---om.MaterialDefinitionID AS CSH, 
	map.CSH AS CSH, 
	(case
		when dbo.JobResponse.WorkType = 'Taring'
		then dbo.OpPackagingActualProperty.Value
		when dbo.JobResponse.WorkType = 'Weighting'
		then (SELECT Value FROM   dbo.PackagingUnitsProperty WHERE	 PackagingUnitsID = dbo.PackagingUnits.ID and [Description]=N'Вес тары' )
	end)									AS Tare, 
	map.brutto		AS Brutto, 
	map.netto       AS Netto, 
	----dbo.OpPackagingActual.ID			AS OpPackagingActualID,
	dbo.JobResponse.StartTime			AS WeightingTime,
	cast(ROW_NUMBER() over (partition by dbo.WorkPerformance.ID, dbo.WorkResponse.ID order by dbo.JobResponse.ID) as int)	AS WeightingIndex,
	cast(DENSE_RANK() over (partition by dbo.WorkPerformance.ID order by dbo.WorkResponse.ID) as int)						AS WagonIndex,
	--map.sndr as sender,
	--map.rcvr as reciever,
	(select top 1 [Description] from dbo.Equipment where ID = map.sndr) [Sender],
	(select top 1 [Description] from dbo.Equipment where ID = map.rcvr) [Receiver],
	opea.Description					as [Person]

FROM
	dbo.JobResponse INNER JOIN
	dbo.WorkResponse ON dbo.JobResponse.WorkResponse = dbo.WorkResponse.ID INNER JOIN
	dbo.WorkPerformance ON dbo.WorkResponse.WorkPerfomence = dbo.WorkPerformance.ID LEFT OUTER JOIN
	dbo.OpPackagingActual ON dbo.JobResponse.ID = dbo.OpPackagingActual.JobResponseID LEFT OUTER JOIN
	dbo.OpPackagingActualProperty ON dbo.OpPackagingActual.ID = dbo.OpPackagingActualProperty.OpPackagingActualID LEFT OUTER JOIN
	dbo.PackagingUnits ON dbo.OpPackagingActual.PackagingUnitsID = dbo.PackagingUnits.ID LEFT OUTER JOIN
	dbo.OpMaterialActual om ON dbo.JobResponse.ID = om.JobResponseID  AND om.MaterialClassID=9 LEFT OUTER JOIN
	--dbo.OpEquipmentActual oe1 ON dbo.JobResponse.ID = oe1.JobResponseID  AND oe1.EquipmentClassID=15 LEFT OUTER JOIN
	--dbo.OpEquipmentActual oe2 ON dbo.JobResponse.ID = oe2.JobResponseID  AND oe2.EquipmentClassID=16 LEFT OUTER JOIN
	--dbo.MaterialActualProperty  brutto ON brutto.OpMaterialActual=om.ID  AND  brutto.[Description]=N'Вес брутто' LEFT OUTER JOIN
	--dbo.MaterialActualProperty  netto  ON netto.OpMaterialActual=om.ID AND  netto.[Description]=N'Вес нетто Дебет'  LEFT OUTER JOIN
	--dbo.MaterialActualProperty  sender ON brutto.OpMaterialActual=om.ID  AND  brutto.[Description]=N'Вес брутто' LEFT OUTER JOIN
	--dbo.MaterialActualProperty  reciever  ON netto.OpMaterialActual=om.ID AND  netto.[Description]=N'Вес нетто Дебет' 
	 dbo.MaterialDefinition ON dbo.MaterialDefinition.ID= om.MaterialDefinitionID  LEFT OUTER JOIN
    (   SELECT   OpMaterialActual, CAST(MAX([Вид лома]) as int) CSH, 
               CAST(MAX([Вес брутто]) as real)  brutto,  CAST(MAX([Вес нетто Дебет]) as real) netto,
		       CAST(MAX([Получатель]) as int) rcvr,  CAST(MAX([Отправитель]) as int)  sndr
        FROM  dbo.MaterialActualProperty 
        PIVOT (MAX(Value) FOR  [Description] in  ([Вид лома], [Вес брутто], [Вес нетто Дебет], [Получатель], [Отправитель]) ) AS pvt   
        GROUP BY OpMaterialActual ) map  
	 ON map.OpMaterialActual=om.ID  LEFT OUTER JOIN
	 [dbo].[OpPersonnelActual] opea ON dbo.JobResponse.ID = opea.JobResponseID 
