
IF OBJECT_ID ('dbo.v_KP4_KIS',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_KP4_KIS];
GO

/*
   View: v_KP4_KIS
   Возвращает отвесные для КИС
*/
create view [dbo].[v_KP4_KIS]
as

SELECT     TOP (100) PERCENT 
	JR.[ID],  
	WP.[Description]								AS [WeightSheetNumber], 
	cast(WP.[StartTime] as smalldatetime)			as [WeightSheetCreateTime],  
	JR.[WorkType]									as [WeighingType], 
	MAP.[SenderID],
	MAP.[ReceiverID],
	(select top 1 [Description] from dbo.Equipment where ID = MAP.[SenderID])	as [Sender],
	(select top 1 [Description] from dbo.Equipment where ID = MAP.[ReceiverID]) as [Receiver],
	PU.[Description]								AS [WagonNumber], 
	WR.[Description]								AS [WaybillNumber],
	MD.[Description]								AS [ScrapGroupName],
	MAP.[CSH]										AS [ScrapCode], 
	(case
		when JR.WorkType = 'Taring'
		then OPAP.Value
		when JR.WorkType = 'Weighting'
		then (SELECT Value FROM dbo.PackagingUnitsProperty WHERE PackagingUnitsID = PU.ID and [Description]=N'Вес тары' )
	end)											AS [Tare], 
	MAP.[Brutto], 
	MAP.[Netto], 
	cast(JR.[StartTime] as smalldatetime)			AS [WeightingTime],
	OPEA.[Description]								as [Weigher]

FROM dbo.JobResponse JR
JOIN dbo.WorkResponse WR
ON JR.WorkResponse = WR.ID 
JOIN dbo.WorkPerformance WP
ON WR.WorkPerfomence = WP.ID 
LEFT JOIN dbo.OpPackagingActual OPA
ON JR.ID = OPA.JobResponseID 
LEFT JOIN dbo.OpPackagingActualProperty OPAP
ON OPA.ID = OPAP.OpPackagingActualID 
LEFT JOIN dbo.PackagingUnits PU
ON OPA.PackagingUnitsID = PU.ID 
LEFT JOIN dbo.OpMaterialActual OM
ON JR.ID = OM.JobResponseID AND OM.MaterialClassID=9  
LEFT JOIN dbo.MaterialDefinition MD
ON MD.ID= OM.MaterialDefinitionID 
LEFT JOIN
	(select 
		 OpMaterialActual
		,[Вид лома]			as [CSH]
		,[Вес брутто]		as [Brutto]
		,[Вес нетто Дебет]	as [Netto]
		,[Получатель]		as [ReceiverID]
		,[Отправитель]		as [SenderID]
	from(
		select Description, Value, OpMaterialActual
		FROM  [dbo].[MaterialActualProperty] MAP
		where [Description] in (N'Вид лома', N'Вес брутто', N'Вес нетто Дебет', N'Получатель', N'Отправитель')
	) as T
	pivot (MAX(Value) FOR  [Description] in  ([Вид лома], [Вес брутто], [Вес нетто Дебет], [Получатель], [Отправитель]) ) as pvt) AS MAP 
ON MAP.OpMaterialActual=OM.ID
LEFT JOIN [dbo].[OpPersonnelActual] OPEA 
ON JR.ID = OPEA.JobResponseID 
where WP.[WorkState]='Closed' and WP.[StartTime] > '20171201'
--order by JR.[ID] desc

  
GO