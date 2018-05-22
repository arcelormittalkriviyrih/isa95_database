SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
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
          AND ep.[Value] = par.JobOrder),
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
                  WHERE kl.[TIMESTAMP] >= DATEADD(hour, -1, GETDATE())
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
																		   AND epv.Value=  left(Command, len(Command)- charindex('.', reverse(Command)))
																		   and DATEDIFF(second, jo.StartTime, CURRENT_TIMESTAMP) > 30 )
						  OR NOT EXISTS (SELECT * from dbo.kep_controller_diag diag where DATEPART(second, CURRENT_TIMESTAMP-diag.Controller_Last_Connect)<5 
																			AND (cast(diag.Controller_ID as nvarchar) = epv2.[Value]))) Send_OPC_Error
          FROM dbo.Equipment eq
               INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
               INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                            AND ecp.value = N'SCALES_NO')
			   INNER JOIN dbo.EquipmentProperty epv ON (epv.EquipmentID=eq.ID)
			   INNER JOIN dbo.EquipmentClassProperty epr ON (epv.ClassPropertyID=epr.ID and epr.Value = N'OPC_DEVICE_NAME')
			   INNER JOIN dbo.Equipment side ON (side.ID = eq.Equipment)
			   INNER JOIN dbo.EquipmentProperty epv2 ON (epv2.EquipmentID=side.ID)
			   INNER JOIN dbo.EquipmentClassProperty epr2 ON (epv2.ClassPropertyID=epr2.ID and epr2.Value = N'CONTROLLER_ID')
               LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1 AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))
               LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = eq.ID AND bw.PropertyType = N'BAR_WEIGHT'
               LEFT OUTER JOIN BarWeight bminW ON bminW.EquipmentId = eq.ID AND bminW.PropertyType = N'MIN_WEIGHT'
               LEFT OUTER JOIN BarWeight bmaxW ON bmaxW.EquipmentId = eq.ID AND bmaxW.PropertyType = N'MAX_WEIGHT'
               LEFT OUTER JOIN BarWeight bQty ON bQty.EquipmentId = eq.ID AND bQty.PropertyType = N'BAR_QUANTITY';
GO