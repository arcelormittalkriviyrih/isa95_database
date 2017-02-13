SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLinkTypes] WHERE [ID]=6)
	INSERT INTO [dbo].[MaterialLinkTypes]
           ([ID]
           ,[Description])
     VALUES
           (6
           ,N'Сторнирование');
	

COMMIT;
GO

