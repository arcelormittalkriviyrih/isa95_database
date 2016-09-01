SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (select * from INFORMATION_SCHEMA.COLUMNS 
where TABLE_NAME = 'MaterialDefinition' and COLUMN_NAME='MaterialDefinitionID')
BEGIN
ALTER TABLE [dbo].[MaterialDefinition] ADD [MaterialDefinitionID] [int] NULL
END


GO
