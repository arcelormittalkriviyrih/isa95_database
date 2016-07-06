IF NOT EXISTS (SELECT NULL FROM [dbo].[EquipmentClassProperty] WHERE [Value]=N'STANDARD_WORK_DEFINITION_ID')
   INSERT INTO [dbo].[EquipmentClassProperty]([Description],[Value],[EquipmentClassID]) (SELECT N'Текущий WorkDefinition с режимом Standard',N'STANDARD_WORK_DEFINITION_ID',eqc.[ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=N'SCALES')
GO

IF NOT EXISTS (SELECT NULL FROM [dbo].[EquipmentClassProperty] WHERE [Value]=N'STANDARD_JOB_ORDER_ID')
   INSERT INTO [dbo].[EquipmentClassProperty]([Description],[Value],[EquipmentClassID]) (SELECT N'Текущий JobOrder с режимом Standard',N'STANDARD_JOB_ORDER_ID',eqc.[ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=N'SCALES')
GO
