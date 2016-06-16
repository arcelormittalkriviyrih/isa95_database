IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_EquipmentClassProperty_Value' AND object_id = OBJECT_ID('[dbo].[EquipmentClassProperty]'))
   DROP INDEX [i1_EquipmentClassProperty_Value] ON [dbo].[EquipmentClassProperty]
GO

CREATE INDEX [i1_EquipmentClassProperty_Value] ON [dbo].[EquipmentClassProperty] ([Value])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_EquipmentProperty_ClassPropertyID' AND object_id = OBJECT_ID('[dbo].[EquipmentProperty]'))
   DROP INDEX [i1_EquipmentProperty_ClassPropertyID] ON [dbo].[EquipmentProperty]
GO

CREATE INDEX [i1_EquipmentProperty_ClassPropertyID] ON [dbo].[EquipmentProperty] ([ClassPropertyID])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i_WEIGHT__FIX_TIMESTAMP' AND object_id = OBJECT_ID('[dbo].[KEP_logger]'))
   DROP INDEX [i_WEIGHT__FIX_TIMESTAMP] ON [dbo].[KEP_logger]
GO

CREATE NONCLUSTERED INDEX [i_WEIGHT__FIX_TIMESTAMP] ON [dbo].[KEP_logger]
(
	 [WEIGHT__FIX_TIMESTAMP] ASC, [WEIGHT__FIX_NUMERICID] ASC
)
INCLUDE ([WEIGHT_CURRENT_VALUE]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO

