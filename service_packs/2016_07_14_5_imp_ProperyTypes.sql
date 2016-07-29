SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'BINDING_DIA')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BINDING_DIA',N'Диаметр увязки');

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'BINDING_QTY')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BINDING_QTY',N'Количество увязок');

COMMIT;
GO

