
IF OBJECT_ID ('dbo.v_WGT_Weightsheet',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_Weightsheet];
GO

/*
   View: v_WGT_Weightsheet
   Возвращает взвешивания вагонов для отвесной
*/
create view [dbo].[v_WGT_Weightsheet] as 

select
	 WO.[ID]
	,WO.[DocumentationsID]
	,WO.[Description]			as [WagonNumber]
	,DP.[Value]					as [WaybillNumber]
	,PUP.[Description]			as [Carrying]
	--,WO.[MaterialDefinitionID]
	,MD.[Description]			as [CSH]
	--,[OperationTime]
	--,WO.[EquipmentID]			as [WeighbridgeID]
	--,[PackagingUnitsDocsID]
	,WO.[Brutto]
	,WO.[Tara]
	,WO.[Netto]
	--,[OperationType]
	--,[TaringTime]
	,WO.[Status]
	--,PUDP.*
	--,D.*
	--,PUD.*
FROM [dbo].[WeightingOperations] WO
left join 
	(select
		 [PackagingUnitsDocsID]
		,[Путевая]		as [WaybillID]
		,[Род груза]	as [CargoTypeID]
	from (
		select
			 [PackagingUnitsDocsID]
			,[Description]
			,[Value]
		from [dbo].[PackagingUnitsDocsProperty] PUDP) as T
	pivot( max([Value]) for [Description] in ([Путевая], [Род груза])) as pvt) as PUDP
on PUDP.[PackagingUnitsDocsID] = WO.[PackagingUnitsDocsID]
join [dbo].[MaterialDefinition] MD
on PUDP.[CargoTypeID] = MD.[ID]
join [dbo].[DocumentationsProperty] DP
on DP.[DocumentationsID] = PUDP.[WaybillID] and DP.[Description] = N'Номер путевой'
join [dbo].[PackagingUnitsDocs] PUD
on PUD.ID = WO.[PackagingUnitsDocsID]
left join [dbo].[PackagingUnitsProperty] PUP
on PUP.[PackagingUnitsID] = PUD.[PackagingUnitsID] and PUP.[Description] = N'Грузоподъемность'

GO