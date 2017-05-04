SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

update [dbo].[PackagingUnits]
set [PackagingClassID] = (select top 1 ID from [PackagingClass] where [Description] = N'Лафет-короб')
where [Description] like '%-%'

GO