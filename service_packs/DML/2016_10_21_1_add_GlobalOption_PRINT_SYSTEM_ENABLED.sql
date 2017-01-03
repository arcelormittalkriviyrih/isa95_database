SET ANSI_NULLS ON
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON
GO

INSERT INTO [dbo].[GlobalOptions]
           ([OptionCode]
           ,[OptionName]
           ,[OptionValue]
           ,[OptionDescription])
     VALUES
           (N'PRINT_SYSTEM_ENABLED'
           ,N'АСПБГП включена'
           ,N'true'
           ,N'Система печати бирок включена, т.е. печатает бирки, управляет контроллерами взвешивания и отправляет бирки в SAP')
GO

