

IF OBJECT_ID ('dbo.v_WGT_Consigners',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_Consigners];
GO

/*
   View: v_WGT_Consigners
    Отправители и получатели грузов
*/
create view dbo.v_WGT_Consigners
as
select
	 E.ID
	,E.[Description]
	,E.[EquipmentLevel]
	,ECP.[Value]		as PropertyDescription
	,EP.[Value]			as PropertyValue
from [dbo].[Equipment] E
left join [dbo].[EquipmentProperty] EP
on EP.[EquipmentID] = E.ID
inner join [dbo].[EquipmentClassProperty] ECP
on EP.ClassPropertyID = ECP.ID
where ECP.[Value] in (N'CONSIGNEE', N'CONSIGNER') and EP.Value = 'true'
--order by E.[Description]

GO