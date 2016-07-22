SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;


INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAP_SERVICE_URL',N'SAP service URL');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAP_SERVICE_LOGIN',N'SAP service login');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAP_SERVICE_PASS',N'SAP service password');

COMMIT;
GO

