SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT NULL FROM [dbo].[EquipmentClassProperty] WHERE [Value]=N'STANDARD_WORK_DEFINITION_ID')
   INSERT INTO [dbo].[EquipmentClassProperty]([Description],[Value],[EquipmentClassID]) (SELECT N'Текущий WorkDefinition с режимом Standard',N'STANDARD_WORK_DEFINITION_ID',eqc.[ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=N'SCALES');

IF NOT EXISTS (SELECT NULL FROM [dbo].[EquipmentClassProperty] WHERE [Value]=N'STANDARD_JOB_ORDER_ID')
   INSERT INTO [dbo].[EquipmentClassProperty]([Description],[Value],[EquipmentClassID]) (SELECT N'Текущий JobOrder с режимом Standard',N'STANDARD_JOB_ORDER_ID',eqc.[ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=N'SCALES');

COMMIT;
GO

