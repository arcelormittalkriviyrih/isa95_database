SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_DiagInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_DiagInfo];
GO
/*
   View: [v_DiagInfo]
    Возвращает диагностические данные по оборудованию
*/
CREATE VIEW [dbo].[v_DiagInfo]
AS
WITH Kep_Data
          AS (SELECT *
              FROM
              (
                  SELECT ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                         kl.[WEIGHT_CURRENT],
                         kl.[WEIGHT_STAB],
                         kl.[WEIGHT_ZERO],
                         kl.[COUNT_BAR],
                         kl.[REM_BAR],
                         kl.[AUTO_MANU],
                         kl.[POCKET_LOC],
                         kl.[PACK_SANDWICH],
                         kl.[NUMBER_POCKET],
					kl.[ALARM]
                  FROM dbo.KEP_logger kl
                  WHERE kl.[TIMESTAMP] >= DATEADD(hour, -1, GETDATE())
              ) ww
              WHERE ww.RowNumber = 1)
SELECT equip.ID,
       equip.[Description] EquipmentName,
	  side.ID SideID,
	  CASE kd.ALARM
	  WHEN 0 THEN N'OK'
	  WHEN 1 THEN N'Error'
	  WHEN NULL THEN NULL
	  END EquipmentStatus
FROM dbo.Equipment side
     INNER JOIN dbo.EquipmentClass ec ON (ec.ID = side.EquipmentClassID and ec.Code=N'SIDE')	
     INNER JOIN dbo.Equipment equip ON (equip.Equipment = side.ID)
	INNER JOIN dbo.EquipmentClass ecs ON (ecs.ID = equip.EquipmentClassID and ecs.Code=N'SCALES')	
     INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = equip.ID)
     INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID AND ecp.value = N'SCALES_NO')
     LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1 AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))     
UNION
SELECT abs(Checksum(NewID())),
	  N'PLC',
	  side.ID,
	  IIF(diag.Controller_Last_Connect IS NULL, NULL, IIF(DATEPART(second, CURRENT_TIMESTAMP-diag.Controller_Last_Connect)>5,N'Error',N'OK'))	  
FROM dbo.Equipment side
     INNER JOIN dbo.EquipmentClass ec ON (ec.ID = side.EquipmentClassID and ec.Code=N'SIDE')
     INNER JOIN dbo.EquipmentProperty ep ON (ep.EquipmentID = side.ID and ep.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' ))
	LEFT OUTER JOIN dbo.kep_controller_diag diag ON (cast(diag.Controller_ID as nvarchar) = ep.[Value])
UNION
SELECT abs(Checksum(NewID())),
 	  N'UPS',
	  side.ID,
	  CASE diag.UPS_FAIL
	  WHEN 1 THEN N'OK'
	  WHEN 0 THEN N'Error'
	  WHEN NULL THEN NULL
	  END
FROM dbo.Equipment side
     INNER JOIN dbo.EquipmentClass ec ON (ec.ID = side.EquipmentClassID and ec.Code=N'SIDE')
     INNER JOIN dbo.EquipmentProperty ep ON (ep.EquipmentID = side.ID and ep.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' ))
	LEFT OUTER JOIN dbo.kep_controller_diag diag ON (cast(diag.Controller_ID as nvarchar) = ep.[Value])
UNION
SELECT equip.ID,
	  equip.[Description],
	  side.ID,
	  dbo.get_EquipmentPropertyValue(equip.ID,N'PRINTER_STATUS')	  
FROM dbo.Equipment side
     INNER JOIN dbo.EquipmentClass ec ON (ec.ID = side.EquipmentClassID and ec.Code=N'SIDE')	
     INNER JOIN dbo.Equipment equip ON (equip.Equipment = side.ID)
	INNER JOIN dbo.EquipmentClass ecs ON (ecs.ID = equip.EquipmentClassID and ecs.Code=N'PRINTER')	;

GO
