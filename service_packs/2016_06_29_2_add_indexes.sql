-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u1_Parameter' AND object_id = OBJECT_ID('[dbo].[Parameter]'))
   DROP INDEX [u1_Parameter] ON [dbo].[Parameter]
GO

CREATE UNIQUE INDEX [u1_Parameter] ON [dbo].[Parameter] ([JobOrder],[PropertyType]) INCLUDE ([Value])
GO
-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u1_SegmentParameter' AND object_id = OBJECT_ID('[dbo].[SegmentParameter]'))
   DROP INDEX [u1_SegmentParameter] ON [dbo].[SegmentParameter]
GO

CREATE UNIQUE INDEX [u1_SegmentParameter] ON [dbo].[SegmentParameter] ([OpSegmentRequirement],[PropertyType]) INCLUDE ([Value])
GO
-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u1_ParameterSpecification' AND object_id = OBJECT_ID('[dbo].[ParameterSpecification]'))
   DROP INDEX [u1_ParameterSpecification] ON [dbo].[ParameterSpecification]
GO

CREATE UNIQUE INDEX [u1_ParameterSpecification] ON [dbo].[ParameterSpecification] ([WorkDefinitionID],[PropertyType]) INCLUDE ([Value])
GO
-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_JobOrder_StartTime_WorkType' AND object_id = OBJECT_ID('[dbo].[JobOrder]'))
   DROP INDEX [i1_JobOrder_StartTime_WorkType] ON [dbo].[JobOrder]
GO
-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_JobOrder' AND object_id = OBJECT_ID('[dbo].[JobOrder]'))
   DROP INDEX [i1_JobOrder] ON [dbo].[JobOrder]
GO

CREATE INDEX [i1_JobOrder] ON [dbo].[JobOrder] ([WorkRequest],[WorkType]) INCLUDE ([StartTime])
GO
-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i2_JobOrder' AND object_id = OBJECT_ID('[dbo].[JobOrder]'))
   DROP INDEX [i2_JobOrder] ON [dbo].[JobOrder]
GO

CREATE INDEX [i2_JobOrder] ON [dbo].[JobOrder] ([WorkRequest],[StartTime]) INCLUDE ([WorkType])
GO
-----------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_OpEquipmentRequirement' AND object_id = OBJECT_ID('[dbo].[OpEquipmentRequirement]'))
   DROP INDEX [i1_OpEquipmentRequirement] ON [dbo].[OpEquipmentRequirement]
GO

CREATE INDEX [i1_OpEquipmentRequirement] ON [dbo].[OpEquipmentRequirement] ([JobOrderID],[EquipmentID])
GO
