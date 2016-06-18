SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'STANDARD',N'Стандарт');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'LENGTH',N'Длина');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MIN_ROD',N'Количество прутков (минимальное)');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CONTRACT_NO',N'КОНТРАКТ №');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'DIRECTION',N'НАПРАВЛЕНИЕ');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PRODUCT',N'Продукция');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CLASS',N'Класс');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'STEEL_CLASS',N'Марка стали');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CHEM_ANALYSIS',N'Хим. Анализ');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BUNT_DIA',N'Диаметр бунта'); 
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'ADDRESS',N'Адрес поставщика');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'COMM_ORDER',N'Заказ');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'TEMPLATE',N'Шаблон бирки');

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BAR_WEIGHT',N'Вес прутка');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BAR_QUANTITY',N'Количество прутков');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MAX_WEIGHT',N'Максимальный вес');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MIN_WEIGHT',N'Минимальный вес');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'DEVIATION',N'Отклонение');

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MEASURE_TIME',N'Дата и время взвешивания');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'AUTO_MANU_VALUE',N'Режим ввода веса');

COMMIT;
GO

