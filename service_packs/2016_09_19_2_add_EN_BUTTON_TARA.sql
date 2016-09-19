SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT NULL
               FROM information_schema.columns
               WHERE table_name = 'KEP_test'
                 AND column_name = 'EN_BUTTON_TARA')
   ALTER TABLE [dbo].[KEP_test] ADD [EN_BUTTON_TARA] [BIT]  NULL
GO

