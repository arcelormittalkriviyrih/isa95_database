SET NUMERIC_ROUNDABORT OFF;
GO

SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

--we do not need KEP_logger cleaning any more
IF OBJECT_ID ('dbo.del_KEPLoggerJob',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_KEPLoggerJob;
GO

IF OBJECT_ID ('dbo.InsKeplogger_archive',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKeplogger_archive];
GO

CREATE TRIGGER [dbo].[InsKeplogger_archive] ON [dbo].[KEP_logger]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   INSERT INTO [dbo].[KEP_logger_archive] SELECT * FROM INSERTED;
   
   DECLARE @insertedID INT, @NUMBER_POCKET INT;

   SELECT @insertedID = id,
		@NUMBER_POCKET = [NUMBER_POCKET]
   FROM INSERTED;
   
   DELETE FROM [dbo].[KEP_logger]
    WHERE NUMBER_POCKET = @NUMBER_POCKET
	   AND ID != @insertedID;

END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKeplogger_archive]', @order=N'First', @stmttype=N'INSERT'
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
	  IIF(diag.Controller_Last_Connect IS NULL, NULL, IIF(DATEDIFF(second, diag.Controller_Last_Connect,CURRENT_TIMESTAMP)>15,N'Error',N'OK'))	  
FROM dbo.Equipment side
     INNER JOIN dbo.EquipmentClass ec ON (ec.ID = side.EquipmentClassID and ec.Code=N'SIDE')
     INNER JOIN dbo.EquipmentProperty ep ON (ep.EquipmentID = side.ID and ep.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' ))
	LEFT OUTER JOIN dbo.kep_controller_diag diag ON (cast(diag.Controller_ID as nvarchar) = ep.[Value])
UNION
SELECT abs(Checksum(NewID())),
 	  N'UPS',
	  side.ID,
	  CASE diag.UPS_FAIL
	  WHEN 0 THEN N'OK'
	  WHEN 1 THEN N'Error'
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

IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO
/*
   View: v_ScalesDetailInfo
    Возвращает данные из контроллера а также расчитывает количество прудков для весов.
	Используется на экране маркиорвщицы.
*/
CREATE VIEW [dbo].[v_ScalesDetailInfo]
AS
     WITH BarWeight
          AS (SELECT CAST(par.[Value] AS FLOAT) PropertyValue,
                     pr.[Value] PropertyType,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value] IN(N'BAR_WEIGHT', N'MIN_WEIGHT', N'MAX_WEIGHT', N'BAR_QUANTITY')
              AND pr.ID = par.PropertyType
              AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
          AND cast(ep.[Value] as nvarchar) = par.JobOrder),
          Kep_Data
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
                         kl.[ALARM],
                         kl.[KEY_MANU],
						 kl.[EN_BUTTON_TARA],
						 kl.[WEIGHT_OK],
						 kl.[PEREBOR]
                  FROM dbo.KEP_logger kl
              ) ww
              WHERE ww.RowNumber = 1)
          SELECT eq.ID AS ID,
                 eq.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) WEIGHT_CURRENT,
                 kd.WEIGHT_STAB,
                 kd.WEIGHT_ZERO,
                 kd.AUTO_MANU,
                 kd.POCKET_LOC,
                 kd.PACK_SANDWICH,
                 kd.ALARM,
                 kd.KEY_MANU,
				 kd.EN_BUTTON_TARA,
                (select ps.Value
                 from [dbo].[ParameterSpecification] ps
                 where ps.WorkDefinitionID=dbo.get_EquipmentPropertyValue(eq.ID,N'WORK_DEFINITION_ID')
                   and ps.PropertyType=dbo.[get_PropertyTypeIdByValue](N'BUNT_NO')) BUNT_NO,
                 CAST(FLOOR(dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) / bw.PropertyValue) AS   INT) RodsQuantity,
                 kd.REM_BAR RodsLeft,
                 ISNULL(CAST(bminW.PropertyValue AS INT), 0) MinWeight,
                 ISNULL(CAST(bmaxW.PropertyValue AS INT), 0) MaxWeight,
                 ISNULL(dbo.get_RoundedWeight(bmaxW.PropertyValue * 1.2, 'UP', 100), dbo.get_EquipmentPropertyValue(eq.ID, N'MAX_WEIGHT')) MaxPossibleWeight,
                 ISNULL(dbo.get_EquipmentPropertyValue(eq.ID, N'SCALES_TYPE'), N'POCKET') SCALES_TYPE,
                 dbo.get_EquipmentPropertyValue(eq.ID, N'PACK_RULE') PACK_RULE,
                 CAST(bQty.PropertyValue AS INT)		BAR_QUANTITY,
                 ISNULL(dbo.get_EquipmentPropertyValue(eq.ID, N'TAKE_WEIGHT_LOCKED'), '0') TAKE_WEIGHT_LOCKED,
				 kd.[WEIGHT_OK],
				 kd.[PEREBOR],
				 (SELECT 1 WHERE EXISTS (SELECT NULL FROM dbo.JobOrder jo WHERE jo.WorkType = N'KEPCommands'
																		   AND jo.DispatchStatus=N'ToSend'   
																		   AND CAST(epv.Value as nvarchar)=  left(Command, len(Command)- charindex('.', reverse(Command)))
																		   and DATEDIFF(second, jo.StartTime, CURRENT_TIMESTAMP) > 15 )
						  OR EXISTS (SELECT * from dbo.kep_controller_diag diag where DATEDIFF(second, diag.Controller_Last_Connect,CURRENT_TIMESTAMP)>15 
																			AND (cast(diag.Controller_ID as nvarchar) = CAST(epv2.[Value] as nvarchar)))) Send_OPC_Error
          FROM dbo.Equipment eq
               INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
               INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                            AND ecp.value = N'SCALES_NO')
			   INNER JOIN dbo.EquipmentProperty epv ON (epv.EquipmentID=eq.ID)
			   INNER JOIN dbo.EquipmentClassProperty epr ON (epv.ClassPropertyID=epr.ID and CAST(epr.Value as nvarchar) = N'OPC_DEVICE_NAME')
			   INNER JOIN dbo.Equipment side ON (side.ID = eq.Equipment)
			   INNER JOIN dbo.EquipmentProperty epv2 ON (epv2.EquipmentID=side.ID)
			   INNER JOIN dbo.EquipmentClassProperty epr2 ON (epv2.ClassPropertyID=epr2.ID and CAST(epr2.Value as nvarchar) = N'CONTROLLER_ID')
               LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1 AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))
               LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = eq.ID AND bw.PropertyType = N'BAR_WEIGHT'
               LEFT OUTER JOIN BarWeight bminW ON bminW.EquipmentId = eq.ID AND bminW.PropertyType = N'MIN_WEIGHT'
               LEFT OUTER JOIN BarWeight bmaxW ON bmaxW.EquipmentId = eq.ID AND bmaxW.PropertyType = N'MAX_WEIGHT'
               LEFT OUTER JOIN BarWeight bQty ON bQty.EquipmentId = eq.ID AND bQty.PropertyType = N'BAR_QUANTITY';
GO

IF OBJECT_ID ('dbo.v_ScalesMonitorInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesMonitorInfo];
GO
/*
   View: v_ScalesMonitorInfo
    Возвращает данные из контроллера а также расчитывает количество прудков для весов.
	Используется на экране маркиорвщицы для показа данных на доп. мониторе.
*/
CREATE VIEW [dbo].[v_ScalesMonitorInfo]
AS
     WITH BarWeight
          AS (SELECT CAST(par.[Value] AS FLOAT) PropertyValue,
                     pr.[Value] PropertyType,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value] IN(N'BAR_WEIGHT', N'BAR_QUANTITY')
              AND pr.ID = par.PropertyType
              AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
          AND ep.[Value] = par.JobOrder),
          Kep_Data
          AS (SELECT *
              FROM
              (
                  SELECT ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                         kl.[WEIGHT_CURRENT],
						 kl.[WEIGHT_STAB],
                         kl.[AUTO_MANU],
                         kl.[KEY_MANU],
                         kl.[POCKET_LOC],
                         kl.[NUMBER_POCKET]
                  FROM dbo.KEP_logger kl
              ) ww
              WHERE ww.RowNumber = 1)
          SELECT eq.ID AS ID,
                 eq.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) WEIGHT_CURRENT,
                 kd.AUTO_MANU,
                 kd.KEY_MANU,
                 kd.POCKET_LOC,
				 kd.WEIGHT_STAB,
                 CAST(FLOOR(dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) / case when bw.PropertyValue=0 then NULL else bw.PropertyValue end) AS   INT) RodsQuantity,
                 CAST(bQty.PropertyValue AS INT)		BAR_QUANTITY
          FROM dbo.Equipment eq
               INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
               INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                            AND ecp.value = N'SCALES_NO')
               LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1
                                              AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))
               LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = eq.ID
                                               AND bw.PropertyType = N'BAR_WEIGHT'
               LEFT OUTER JOIN BarWeight bQty ON bQty.EquipmentId = eq.ID
                                                  AND bQty.PropertyType = N'BAR_QUANTITY';
GO