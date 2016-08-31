SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF exists (select * from [dbo].[KPPRoles] where [RoleName] = 'WeightAnalytics')
	return

INSERT INTO [dbo].[KPPRoles]([RoleName],[ADRoleName])
VALUES('WeightAnalytics','EUROPE\KRR-LG-PA-Weight Analytics')

GO
