
IF OBJECT_ID ('dbo.v_AllWeighbridges',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_AllWeighbridges];
GO

/*
   View: v_AllWeighbridges
   Возвращает список всех платформенных весов
*/

create view [dbo].[v_AllWeighbridges]
AS

select distinct
	 E.[ID]
	,E.[Description]
	,E1.[Description]	as [ParentDescription]
	,EP.[Value]			as [ScalesType]
from [dbo].[Equipment] E
join [dbo].[Equipment] E1
on E1.[ID] = E.[Equipment]
join [dbo].[EquipmentClassProperty] ECP
on ECP.[EquipmentClassID] = E.[EquipmentClassID] and ECP.[Value] = N'SCALES_TYPE'
join [dbo].[EquipmentProperty] EP
on EP.[EquipmentID] = E.[ID] and EP.[ClassPropertyID] = ECP.[ID] and EP.[Value] in (N'WBStatic', N'WBDynamic', N'WBAuto')

GO