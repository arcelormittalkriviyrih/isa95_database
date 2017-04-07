

IF OBJECT_ID ('dbo.v_WGT_Consigners',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_Consigners];
GO

/*
   View: v_WGT_Consigners
    Отправители и получатели грузов
*/
create view dbo.v_WGT_Consigners
as
SELECT
	 E.[ID]
	,E.[Description]
	,E.[EquipmentLevel]
	,EE.[ID]			as ParentID
	,EE.[Description]	as ParentDescription
	,ECP.[Value]		as PropertyDescription
	,EP.[Value]			as PropertyValue
FROM [dbo].[Equipment] E
left join [dbo].[Equipment] EE
on EE.ID = E.Equipment
left join [dbo].[EquipmentProperty] EP
on EP.[EquipmentID] = EE.ID
inner join [dbo].[EquipmentClassProperty] ECP
on EP.ClassPropertyID = ECP.ID
where ECP.[Value] in (N'CONSIGNEE', N'CONSIGNER') and EP.Value = 'true'
--order by EE.[Description], E.[Description]

GO