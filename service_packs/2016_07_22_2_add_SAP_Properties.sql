SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'SAP_SERVICE_URL')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAP_SERVICE_URL',N'SAP service URL');

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'SAP_SERVICE_LOGIN')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAP_SERVICE_LOGIN',N'SAP service login');

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'SAP_SERVICE_PASS')
	INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAP_SERVICE_PASS',N'SAP service password');

COMMIT;
GO

