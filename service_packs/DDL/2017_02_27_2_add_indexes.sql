SET NUMERIC_ROUNDABORT OFF;
GO

SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i3_JobOrder' AND object_id = OBJECT_ID('[dbo].[JobOrder]'))
   DROP INDEX [i3_JobOrder] ON [dbo].[JobOrder]
GO

CREATE NONCLUSTERED INDEX i3_JobOrder
ON [dbo].[JobOrder] ([WorkType],[DispatchStatus])
INCLUDE ([StartTime],[Command])
GO


IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_Parameter' AND object_id = OBJECT_ID('[dbo].[Parameter]'))
   DROP INDEX [i1_Parameter] ON [dbo].[Parameter]
GO

CREATE NONCLUSTERED INDEX i1_Parameter
ON [dbo].[Parameter] ([PropertyType])
INCLUDE ([Value],[JobOrder])
GO