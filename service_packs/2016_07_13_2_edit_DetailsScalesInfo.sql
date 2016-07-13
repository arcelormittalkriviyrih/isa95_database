SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO

CREATE VIEW [dbo].[v_ScalesDetailInfo]
AS
WITH BarWeight
          AS (SELECT cast(par.[Value] as float) PropertyValue,pr.[Value] PropertyType,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value]  in (N'BAR_WEIGHT',N'MIN_WEIGHT',N'MAX_WEIGHT')
                    AND pr.ID = par.PropertyType
                    AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
              AND ep.[Value] = par.JobOrder)
          SELECT ww.EquipmentID AS ID,
                 ww.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(ww.WEIGHT_CURRENT, ww.EquipmentID) WEIGHT_CURRENT,
                 ww.WEIGHT_STAB,
                 ww.WEIGHT_ZERO,
                 ww.AUTO_MANU,
                 ww.POCKET_LOC,
                 ww.PACK_SANDWICH,
                 CAST(0 AS BIT) AS ALARM,
                 cast(FLOOR(dbo.get_RoundedWeightByEquipment(ww.WEIGHT_CURRENT, ww.EquipmentID) / bw.PropertyValue) as int) RodsQuantity,
                 ww.REM_BAR RodsLeft,
			  isnull(cast(bminW.PropertyValue as int),0) MinWeight,
			  isnull(cast(bmaxW.PropertyValue as int),0) MaxWeight,
			  isnull(dbo.get_RoundedWeight(bmaxW.PropertyValue*1.2,'UP',100), dbo.get_EquipmentPropertyValue(ww.EquipmentId,N'MAX_WEIGHT')) MaxPossibleWeight,
			  isnull(dbo.get_EquipmentPropertyValue(730,N'SCALES_TYPE'),N'POCKET') SCALES_TYPE
          FROM
          (
              SELECT eq.ID EquipmentID,
                     eq.[Description],
                     ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                     kl.[WEIGHT_CURRENT],
                     kl.[WEIGHT_STAB],
                     kl.[WEIGHT_ZERO],
                     kl.[COUNT_BAR],
                     kl.[REM_BAR],
                     kl.[AUTO_MANU],
                     kl.[POCKET_LOC],
                     kl.[PACK_SANDWICH]
              FROM dbo.Equipment eq
                   INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
                   INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                                AND ecp.value = N'SCALES_NO')
                   INNER JOIN dbo.KEP_logger kl ON(ISNUMERIC(eqp.value) = 1
                                                   AND kl.[NUMBER_POCKET] = CAST(eqp.value AS INT)
                                                   AND kl.[TIMESTAMP] >= DATEADD(hour, -1, GETDATE()))
          ) ww
          LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = ww.EquipmentID and bw.PropertyType=N'BAR_WEIGHT'
		  LEFT OUTER JOIN BarWeight bminW ON bminW.EquipmentId = ww.EquipmentID and bminW.PropertyType=N'MIN_WEIGHT'
		  LEFT OUTER JOIN BarWeight bmaxW ON bmaxW.EquipmentId = ww.EquipmentID and bmaxW.PropertyType=N'MAX_WEIGHT'
          WHERE ww.RowNumber = 1;

GO	
