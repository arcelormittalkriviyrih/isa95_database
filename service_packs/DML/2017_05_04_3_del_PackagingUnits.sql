SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*remove root in PackagingUnits*/
delete from [dbo].[PackagingUnits]
where [Description] = 'Root'

GO