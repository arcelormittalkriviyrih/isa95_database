SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*remove root reference in PackagingUnitsProperty*/
update [dbo].[PackagingUnitsProperty]
set [PackagingUnitsProperty] = null
where [PackagingUnitsProperty] = 0

GO