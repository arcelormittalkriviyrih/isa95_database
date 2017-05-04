SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*remove root in PackagingUnitsProperty*/
delete from [dbo].[PackagingUnitsProperty]
where [Description] = 'Root'

GO