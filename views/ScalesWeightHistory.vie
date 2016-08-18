SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ScalesWeightHistory',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesWeightHistory];
GO
/*
   View: v_ScalesWeightHistory
    Весовые данные для построения графиков
*/
CREATE VIEW [dbo].[v_ScalesWeightHistory]
AS
SELECT eq.ID AS ID,
       eq.[Description] AS ScalesName,
	  eq.Equipment	SideID,
       kl.[WEIGHT_CURRENT],
       ToDateTimeOffset(kl.[TIMESTAMP],0) WEIGHT_TIMESTAMP
FROM dbo.Equipment eq
     INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
     INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                  AND ecp.value = N'SCALES_NO')
     INNER JOIN dbo.KEP_logger_archive kl ON(ISNUMERIC(eqp.value) = 1
                                             AND kl.[NUMBER_POCKET] = CAST(eqp.value AS INT));
GO