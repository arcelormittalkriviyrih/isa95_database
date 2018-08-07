

IF OBJECT_ID ('dbo.v_WGT_Consigners',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_Consigners];
GO

/*
   View: v_WGT_Consigners
    Отправители и получатели грузов
*/
create view [dbo].[v_WGT_Consigners]
as

with CTE_Prop as (
select
	 EP.[Description]
	,EP.[Value]
	,EP.[EquipmentID]
	,ECP.[Value] as [Property]
from [dbo].[EquipmentProperty] EP
join [dbo].[EquipmentClassProperty] ECP
on EP.ClassPropertyID = ECP.ID and ECP.[Value] in (N'CONSIGNEE', N'CONSIGNER', N'SAP_CODE')
)

select
	 E.[ID]
	,E.[Description]
	,E.[EquipmentLevel]
	,EE.[ID]			as [ParentID]
	,EE.[Description]	as [ParentDescription]
	,P.[Property]		as [PropertyDescription]
	,P.[Value]			as [PropertyValue]
	,P1.[Value]			as [SAPCode]
from [dbo].[Equipment] E
left join [dbo].[Equipment] EE
on EE.ID = E.Equipment
join CTE_Prop P
on P.[EquipmentID] = EE.[ID] and P.[Property] in (N'CONSIGNEE', N'CONSIGNER') and P.[Value] = N'true'
left join CTE_Prop P1
on P1.[EquipmentID] = E.[ID] and P1.[Property] = N'SAP_CODE'
--order by EE.[Description], E.[Description]

GO