SET ANSI_NULLS ON;
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON;
GO

INSERT INTO [dbo].[MaterialClassProperty]   ([Description],[Value],[MaterialClassID])  VALUES ( N'Вид лома', N'Scrap type',9 )
INSERT INTO [dbo].[MaterialClassProperty]   ([Description],[Value],[MaterialClassID])  VALUES ( N'Вес нетто Дебет', N'Netto debit',9 )
INSERT INTO [dbo].[MaterialClassProperty]   ([Description],[Value],[MaterialClassID])  VALUES ( N'Вес нетто Кредит', N'Netto credit',9 )
INSERT INTO [dbo].[MaterialClassProperty]   ([Description],[Value],[MaterialClassID])  VALUES ( N'Вес брутто', N'Brutto',9 )
INSERT INTO [dbo].[MaterialClassProperty]   ([Description],[Value],[MaterialClassID])  VALUES ( N'Отправитель', N'Sender',9 )
INSERT INTO [dbo].[MaterialClassProperty]   ([Description],[Value],[MaterialClassID])  VALUES ( N'Получатель', N'Receiver',9 )

    
Update [dbo].[MaterialClass] SET [Description]=N'Лом', [Code]=N'Scrap'
WHERE ID=9


GO