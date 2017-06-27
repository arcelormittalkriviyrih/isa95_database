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
PRINT N'New script. Applying...'
GO

:r $(FileName)
:On Error exit
GO

INSERT INTO dbo.ServicePacksFiles(FileName) VALUES(N'$(FileName)')

PRINT N'Script processed'
GO
