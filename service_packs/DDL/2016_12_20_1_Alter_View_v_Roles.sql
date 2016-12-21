SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
   View: v_Roles
    Возвращает список доступных ролей.
*/
ALTER VIEW [dbo].[v_Roles]
AS

select 
	min(ID) as ID,
	RoleName
from(
	SELECT kppr.ID,
		   kppr.RoleName
	FROM sys.server_permissions sper
	INNER JOIN sys.server_principals sprin 
	ON (sprin.principal_id=sper.grantee_principal_id AND sprin.is_disabled=0 AND sprin.type=N'G' AND sprin.type_desc=N'WINDOWS_GROUP')
	INNER JOIN dbo.KPPRoles kppr 
	ON (kppr.ADRoleName=sprin.name)
) as T
group by RoleName
order by min(ID)


GO

