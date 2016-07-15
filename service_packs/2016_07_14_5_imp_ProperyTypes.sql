SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BINDING_DIA',N'Диаметр увязки');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BINDING_QTY',N'Количество увязок');

COMMIT;
GO

