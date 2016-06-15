SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAMPLE_WEIGHT',N'Масса образца');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAMPLE_LENGTH',N'Длина образца');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PROD_ORDER',N'Производственный заказ');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PROD_DATE',N'Производственная дата');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MELT_NO',N'Плавка');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PART_NO',N'Партия');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BUNT_NO',N'№ бунта');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'LEAVE_NO',N'№ отпуска');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CHANGE_NO',N'Смена');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BRIGADE_NO',N'Бригада');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SIZE',N'Размер');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'TOLERANCE',N'Допуск');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BUYER_ORDER_NO',N'ЗАКАЗ  № (№ заказа у покупателя)');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'UTVK',N'УТВК');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MATERIAL_NO',N'№ материала');

UPDATE [dbo].[PropertyTypes] set [Description]= N'Коммерческий заказ' where [Value]='COMM_ORDER';
UPDATE [dbo].[PropertyTypes] set [Description]= N'Производственный заказ' where [Value]='PROD_ORDER';
UPDATE [dbo].[PropertyTypes] set [Description]= N'Бригада' where [Value]='BRIGADE_NO';
UPDATE [dbo].[PropertyTypes] set [Description]= N'Смена' where [Value]='LEAVE_NO';
UPDATE [dbo].[PropertyTypes] set [Description]= N'Диаметр бунта' where [Value]='BUNT_DIA';
UPDATE [dbo].[PropertyTypes] set [Description]= N'Количество прутков' where [Value]='MIN_ROD';

