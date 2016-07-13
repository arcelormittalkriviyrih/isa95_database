SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Обновление структур таблиц
IF NOT EXISTS (SELECT NULL
               FROM information_schema.columns
               WHERE table_name = 'Files'
                 AND column_name = 'PreviewID')
BEGIN
   ALTER TABLE [dbo].[Files] ADD [PreviewID] int NULL;   
   ALTER TABLE [dbo].[Files] WITH CHECK ADD  CONSTRAINT [FK_Files_PreviewID] FOREIGN KEY([PreviewID]) REFERENCES [dbo].[Files] ([ID]);   
END
GO