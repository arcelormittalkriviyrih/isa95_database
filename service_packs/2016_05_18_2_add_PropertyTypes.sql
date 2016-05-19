BEGIN TRANSACTION;

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'STD',N'Стандарт');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'LEN',N'Длина');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'QMIN',N'Количество прутков (минимальное)');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CONTR',N'КОНТРАКТ №');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'DIR',N'НАПРАВЛЕНИЕ');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PROD',N'Продукция');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CLASS',N'Класс');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'STCLASS',N'Марка стали');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CHEM',N'Хим. Анализ');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'DIAM',N'Диаметр бунта'); 
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'ADR',N'Адрес поставщика');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'ORDER',N'Заказ');

COMMIT;
GO

