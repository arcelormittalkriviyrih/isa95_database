SET NUMERIC_ROUNDABORT OFF;
GO

SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'KEP_logger_archive'
                AND column_name = 'WEIGHT_TIMESTAMP')
   ALTER TABLE dbo.KEP_logger_archive ADD [WEIGHT_TIMESTAMP] AS ToDateTimeOffset([TIMESTAMP],0)
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_KEP_Logger_Archive' AND object_id = OBJECT_ID('[dbo].[KEP_logger_archive]'))
   DROP INDEX [i1_KEP_Logger_Archive] ON [dbo].[KEP_logger_archive]
GO

CREATE INDEX i1_KEP_Logger_Archive ON [dbo].[KEP_logger_archive] ([WEIGHT_TIMESTAMP])
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
SELECT kl.id ID,
       eq.ID AS EquipmentID,
       eq.[Description] AS ScalesName,
       eq.Equipment	SideID,
       kl.[WEIGHT_CURRENT],
       kl.[WEIGHT_TIMESTAMP]
FROM dbo.Equipment eq
     INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
     INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                  AND ecp.value = N'SCALES_NO')
     INNER JOIN dbo.KEP_logger_archive kl ON(ISNUMERIC(eqp.value) = 1
                                             AND kl.[NUMBER_POCKET] = CAST(eqp.value AS INT));
GO
