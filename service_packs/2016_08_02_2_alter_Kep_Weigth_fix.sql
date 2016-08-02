SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'kep_weigth_fix'
                AND column_name = 'IDENT')
   ALTER TABLE [dbo].[kep_weigth_fix] ADD [IDENT] [INT]  NULL
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'kep_weigth_fix_archive'
                AND column_name = 'IDENT')
   ALTER TABLE [dbo].kep_weigth_fix_archive ADD [IDENT] [INT]  NULL
GO

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'MATERIAL_LOT_IDENT')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MATERIAL_LOT_IDENT',N'Material Lot Ident');
GO	