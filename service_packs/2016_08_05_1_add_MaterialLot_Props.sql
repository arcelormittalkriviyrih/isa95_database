SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'CREATOR')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CREATOR',N'Создал');
	
IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'CREATE_MODE')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CREATE_MODE',N'Режим создания');
	
	
update [dbo].[PropertyTypes] set [Description] = N'Идентификатор взвешивания' where [Value]=N'MATERIAL_LOT_IDENT';	

COMMIT;
GO

