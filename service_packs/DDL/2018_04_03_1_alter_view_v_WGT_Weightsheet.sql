
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
	,WO.[DocumentationsID]		as [WeightsheetID]
	,PUD.[PackagingUnitsID]		as [WagonID]
	,WO.[Description]			as [WagonNumber]
	,DP.[DocumentationsID]		as [WaybillID]
	,DP.[Value]					as [WaybillNumber]
	,PUP.[Description]			as [Carrying]
	,WO.[MaterialDefinitionID]	as [CargoTypeID]
	,MD.[Description]			as [CargoType]
	,DP1.[Value]				as [CargoTypeNotes]
	--,WO.[EquipmentID]			as [WeighbridgeID]
	--,[PackagingUnitsDocsID]
	,WO.[Brutto]
	,WO.[Tara]
	,WO.[Netto]
	--,[OperationType]
	,WO.[Status]
	--,WO.[OperationTime]
	,convert(nvarchar(10) ,cast(WO.[OperationTime] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast(WO.[OperationTime] as datetime), 108) as [OperationTime]
	--,WO.[TaringTime]
	,convert(nvarchar(10) ,cast(WO.[TaringTime] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast(WO.[TaringTime] as datetime), 108) as [TaringTime]
	--,PUDP.*
	--,D.*
	--,PUD.*
	--,DP.*
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
left join [dbo].[MaterialDefinition] MD
on PUDP.[CargoTypeID] = MD.[ID]
left join [dbo].[v_WGT_DocumentsProperty] DP
on DP.[DocumentationsID] = PUDP.[WaybillID] and DP.[Description] = N'Номер путевой'
left join [dbo].[v_WGT_DocumentsProperty] DP1
on DP1.[DocumentationsID] = PUDP.[WaybillID] and DP1.[Description] = N'Примечание к роду груза'
left join [dbo].[PackagingUnitsDocs] PUD
on PUD.ID = WO.[PackagingUnitsDocsID]
left join [dbo].[PackagingUnitsProperty] PUP
on PUP.[PackagingUnitsID] = PUD.[PackagingUnitsID] and PUP.[Description] = N'Грузоподъемность'

GO