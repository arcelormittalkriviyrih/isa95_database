
IF OBJECT_ID ('dbo.v_WGT_WeightsheetForSAP',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WeightsheetForSAP];
GO



/*
   View: v_WeightsheetForSAP
   Возвращает отвесные для SAP
*/
create view [dbo].[v_WGT_WeightsheetForSAP]
as

select
	 WO.[ID]
	,vDP1.[Value]								as [WeightSheetNumber]
	,cast(D.[StartTime] as datetime)			as [WeightSheetCreateTime]
	,cast(D.[EndTime]	as datetime)			as [WeightSheetCloseTime]
	--,WO.[OperationType]							as [WeighingType]
	,WO.[EquipmentID]							as [ScalesID]
	,(select top 1 [Description] from [Equipment] where ID = WO.EquipmentID) as [ScalesName]
	,vDP2.[Value]								as [SenderID]
	,vDP3.[Value]								as [ReceiverID]
	,vDP2.[Value2]								as [Sender]
	,vDP3.[Value2]								as [Receiver]
	,(select top 1 [Value] from [dbo].[EquipmentProperty] EP where EP.[Description] = N'Код SAP' and EP.[EquipmentID] = vDP2.[Value]) as [SenderSAPCode]
	,(select top 1 [Value] from [dbo].[EquipmentProperty] EP where EP.[Description] = N'Код SAP' and EP.[EquipmentID] = vDP3.[Value]) as [ReceiverSAPCode]
	,WO.[Description]							as [WagonNumber]
	,PUDP.[Value]								as [WaybillNumber]
	,vST.[Description]							as [ScrapGroupName]
	,vST.[ScrapClassID]							as [ScrapSAPCode]
	,WO.[Tara]									as [Tare]
	,WO.[Brutto]								as [Brutto]
	,WO.[Netto]									as [Netto]
	,cast(WO.[OperationTime] as datetime)		as [WeightingTime]
	,cast(WO.[TaringTime] as datetime)			as [TaringTime]
	,cast(WOP.[Value] as real)					as [Carrying]
	,cast(WOP1.[Value] as real)					as [MarkedTare]
	--,vDP4.[Value2]								as [Weigher]
	--,(select top 1 [PersonName] from [dbo].[Person] where [ID] = WO.[PersonID])			as [Weigher]
	--,(select top 1 [PersonName] from [dbo].[Person] where [ID] = WO.[TaringPersonID])	as [TareWeigher]
	,WGB.[Value]								as [Weigher]
	,WGT.[Value]								as [TareWeigher]

from [dbo].[WeightingOperations] WO
join [dbo].[Documentations] D
on WO.[DocumentationsID] = D.[ID]
left join [dbo].[v_WGT_DocumentsProperty] vDP1
on vDP1.[DocumentationsID] = WO.[DocumentationsID] and vDP1.[Description2] = N'WeightsheetNumber'
left join [dbo].[v_WGT_DocumentsProperty] vDP2
on vDP2.[DocumentationsID] = WO.[DocumentationsID] and vDP2.[Description2] = N'SenderShop'
left join [dbo].[v_WGT_DocumentsProperty] vDP3
on vDP3.[DocumentationsID] = WO.[DocumentationsID] and vDP3.[Description2] = N'ReceiverShop'
-- left join [dbo].[v_WGT_DocumentsProperty] vDP4
-- on vDP4.[DocumentationsID] = WO.[DocumentationsID] and vDP4.[Description2] = N'Weigher'
left join [dbo].[PackagingUnitsDocsProperty] PUDP
on PUDP.[PackagingUnitsDocsID] = WO.[PackagingUnitsDocsID] and PUDP.[Description] = N'Путевая'
left join [dbo].[v_WGT_ScrapTypes] vST
on vST.[ID] = WO.[MaterialDefinitionID]
left join [dbo].[WeightingOperationsProperty] WOP
on WOP.[WeightingOperationsID] = WO.[ID] and WOP.[Description] = N'Грузоподъемность'
left join [dbo].[WeightingOperationsProperty] WOP1
on WOP1.[WeightingOperationsID] = WO.[ID] and WOP1.[Description] = N'Тара с бруса'
outer apply (
	select top 1 
		PP.[Value]
	from [dbo].[PersonProperty] PP
	join [dbo].[PersonnelClassProperty] PCP
	on PCP.[ID] = PP.[ClassPropertyID] and PCP.[Description] = N'Active directory login' and PP.[PersonID] = WO.[PersonID]
) WGB
outer apply (
	select top 1 
		PP.[Value]
	from [dbo].[PersonProperty] PP
	join [dbo].[PersonnelClassProperty] PCP
	on PCP.[ID] = PP.[ClassPropertyID] and PCP.[Description] = N'Active directory login' and PP.[PersonID] = WO.[TaringPersonID]
) WGT

where	isnull(WO.Status, '') != N'reject'
	and isnull(D.Status, '')   = N'closed'
	and WO.[OperationType] = N'Погрузка'
	and D.[EndTime] is not null
--order by WO.id desc

GO