
IF OBJECT_ID ('dbo.v_KP4_KIS',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_KP4_KIS];
GO

/*
   View: v_KP4_KIS
   Возвращает отвесные для КИС
*/
create view [dbo].[v_KP4_KIS]
as

select
	 WO.[ID]
	,vDP1.[Value]								as [WeightSheetNumber]
	,cast(D.[StartTime] as smalldatetime)		as [WeightSheetCreateTime]
	,cast(D.[EndTime]	as smalldatetime)		as [WeightSheetCloseTime]
	,WO.[OperationType]							as [WeighingType]
	,vDP2.[Value]								as [SenderID]
	,vDP3.[Value]								as [ReceiverID]
	,vDP2.[Value2]								as [Sender]
	,vDP3.[Value2]								as [Receiver]
	,WO.[Description]							as [WagonNumber]
	,PUDP.[Value]								as [WaybillNumber]
	,vST.[Description]							as [ScrapGroupName]
	,vST.[ScrapClassID]							as [ScrapCode]
	,WO.[Tara]									as [Tare]
	,WO.[Brutto]								as [Brutto]
	,WO.[Netto]									as [Netto]
	,cast(WO.[OperationTime] as smalldatetime)	as [WeightingTime]
	,vDP4.[Value2]								as [Weigher]
	,(select top 1 [Value] from [dbo].[EquipmentProperty] EP where EP.[Description] = N'Код SAP' and EP.[EquipmentID] = vDP2.[Value]) as [SenderSAPCode]
	,(select top 1 [Value] from [dbo].[EquipmentProperty] EP where EP.[Description] = N'Код SAP' and EP.[EquipmentID] = vDP3.[Value]) as [ReceiverSAPCode]
	
	--,WO.[EquipmentID]
	--,WO.[PackagingUnitsDocsID]
	--,WO.[DocumentationsID]
	--,WO.[TaringTime]
	--,WO.[Status]

from [dbo].[WeightingOperations] WO
join [dbo].[Documentations] D
on WO.[DocumentationsID] = D.[ID]
left join [dbo].[v_WGT_DocumentsProperty] vDP1
on vDP1.[DocumentationsID] = WO.[DocumentationsID] and vDP1.[Description2] = N'WeightsheetNumber'
left join [dbo].[v_WGT_DocumentsProperty] vDP2
on vDP2.[DocumentationsID] = WO.[DocumentationsID] and vDP2.[Description2] = N'SenderShop'
left join [dbo].[v_WGT_DocumentsProperty] vDP3
on vDP3.[DocumentationsID] = WO.[DocumentationsID] and vDP3.[Description2] = N'ReceiverShop'
left join [dbo].[v_WGT_DocumentsProperty] vDP4
on vDP4.[DocumentationsID] = WO.[DocumentationsID] and vDP4.[Description2] = N'Weigher'
left join [dbo].[PackagingUnitsDocsProperty] PUDP
on PUDP.[PackagingUnitsDocsID] = WO.[PackagingUnitsDocsID] and PUDP.[Description] = N'Путевая'
left join [dbo].[v_WGT_ScrapTypes] vST
on vST.[ID] = WO.[MaterialDefinitionID]

where	isnull(WO.Status, '') != N'reject'
	and isnull(D.Status, '')   = N'closed'

--order by WO.id desc

  
GO