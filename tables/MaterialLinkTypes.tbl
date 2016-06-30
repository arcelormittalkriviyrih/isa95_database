IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_MaterialLotLinks' AND object_id = OBJECT_ID('[dbo].[MaterialLotLinks]'))
   DROP INDEX [i1_MaterialLotLinks] ON [dbo].[MaterialLotLinks]
GO

CREATE INDEX i1_MaterialLotLinks ON [dbo].[MaterialLotLinks] ([MaterialLot1])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i2_MaterialLotLinks' AND object_id = OBJECT_ID('[dbo].[MaterialLotLinks]'))
   DROP INDEX [i2_MaterialLotLinks] ON [dbo].[MaterialLotLinks]
GO

CREATE INDEX i2_MaterialLotLinks ON [dbo].[MaterialLotLinks] ([MaterialLot2])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i3_MaterialLotLinks' AND object_id = OBJECT_ID('[dbo].[MaterialLotLinks]'))
   DROP INDEX [i3_MaterialLotLinks] ON [dbo].[MaterialLotLinks]
GO

CREATE INDEX i3_MaterialLotLinks ON [dbo].[MaterialLotLinks] ([LinkType])
GO
