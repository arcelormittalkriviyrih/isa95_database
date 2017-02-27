USE [KRR-PA-ISA95_PRODUCTION]
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON
GO

UPDATE [dbo].[MaterialDefinition] 
  SET [Description]=N'Кислород', [MaterialClassID]=10000
  Where ID=10000
GO

UPDATE [dbo].[MaterialDefinition] 
  SET [Description]=N'Азот', [MaterialClassID]=10000
  Where ID=10001
GO

UPDATE [dbo].[MaterialDefinition] 
  SET [Description]=N'Сжатый воздух', [MaterialClassID]=10000
  Where ID=10002
GO