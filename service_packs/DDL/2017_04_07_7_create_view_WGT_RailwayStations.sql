

IF OBJECT_ID ('dbo.v_WGT_RailwayStations',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_RailwayStations];
GO

/*
   View: v_WGT_RailwayStations
    ЖД станции
*/
create view dbo.v_WGT_RailwayStations
as
SELECT
	 E.[ID]
	,E.[Description]
	,E.[EquipmentLevel]
	,ECP.[Value]		as PropertyDescription
	,EP.[Value]			as PropertyValue
FROM [dbo].[Equipment] E
left join [dbo].[EquipmentProperty] EP
on EP.[EquipmentID] = E.ID
inner join [dbo].[EquipmentClassProperty] ECP
on EP.ClassPropertyID = ECP.ID
where ECP.[Value] in (N'RAILWAY STATION') and EP.Value = 'true'

GO