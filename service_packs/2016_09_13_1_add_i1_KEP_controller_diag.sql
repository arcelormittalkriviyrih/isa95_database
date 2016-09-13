IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_KEP_controller_diag' AND object_id = OBJECT_ID('[dbo].[KEP_controller_diag]'))
   DROP INDEX [i1_KEP_controller_diag] ON [dbo].[KEP_controller_diag]
GO

CREATE INDEX [i1_KEP_controller_diag] ON [dbo].[KEP_controller_diag] ([Controller_ID],[ID])
GO

