SET NOCOUNT ON

:On Error exit

PRINT N'BEGIN SCRIPT FileName=$(FileName)'
GO

PRINT N'New script. Applying...'
:r $(FileName)
:On Error exit

PRINT N'Script processed'
GO
