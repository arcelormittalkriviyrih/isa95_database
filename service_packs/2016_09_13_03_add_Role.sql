SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF exists (select * from [dbo].[KPPRoles] where [RoleName] = 'Acceptance')
	return

INSERT INTO [dbo].[KPPRoles]([RoleName],[ADRoleName])
VALUES('Acceptance','EUROPE\KRR-LG-SQL-PAHWL-DATP_Acceptance')

GO