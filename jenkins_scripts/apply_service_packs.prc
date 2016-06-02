SET NOCOUNT ON

:On Error exit

IF OBJECT_ID ('dbo.ServicePacksFiles',N'U') IS NULL
   CREATE TABLE dbo.ServicePacksFiles (
	[ID] [int] IDENTITY(1,1) PRIMARY KEY CLUSTERED,
	[FileName] [nvarchar](255) NOT NULL,
	[DateChange] [datetimeoffset] NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT UK1_FileName UNIQUE(FileName)
	)
GO

PRINT N'BEGIN SCRIPT FileName=$(FileName)'
GO

IF NOT EXISTS (SELECT NULL FROM dbo.ServicePacksFiles WHERE FileName = N'$(FileName)')
BEGIN
   SET NOEXEC OFF
   PRINT N'New script. Applying...'
   
END
ELSE
BEGIN
   PRINT N'Already applied script, skipping...'
   SET NOEXEC ON
END
GO

:r $(FileName)
:On Error exit
INSERT INTO dbo.ServicePacksFiles(FileName) VALUES(N'$(FileName)')

SET NOEXEC OFF

PRINT N'Script processed'
GO
