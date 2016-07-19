SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_Roles', N'V') IS NOT NULL
   DROP VIEW dbo.v_Roles;
GO

CREATE VIEW dbo.v_Roles
AS
SELECT kppr.ID,
       kppr.RoleName
FROM sys.server_permissions sper
     INNER JOIN sys.server_principals sprin ON (sprin.principal_id=sper.grantee_principal_id AND sprin.is_disabled=0 AND sprin.type=N'G' AND sprin.type_desc=N'WINDOWS_GROUP')
     INNER JOIN dbo.KPPRoles kppr ON (kppr.ADRoleName=sprin.name)
GO
