SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO



ALTER TABLE [KRR-PA-ISA95_PRODUCTION].[dbo].[KPPRoles]
DROP CONSTRAINT RoleName

INSERT INTO [dbo].[KPPRoles] ([RoleName],[ADRoleName]) VALUES (  'WeightAnalytics','EUROPE\KRR-LG-PA-Weight_Analytics-Stakeholders')
INSERT INTO [dbo].[KPPRoles] ([RoleName],[ADRoleName]) VALUES (  'WeightAnalytics','EUROPE\KRR-LG-PA-Developers_DB')

GO