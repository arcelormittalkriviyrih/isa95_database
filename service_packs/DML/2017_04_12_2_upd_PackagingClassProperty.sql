SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*reset PackagingClassProperty*/
update [dbo].[PackagingClassProperty]
set [PackagingClassProperty] = null

/*fix Wagon number templates*/
update [dbo].[PackagingClassProperty]
set Value =	case PC.Description
						when N'Лафет-короб'		then N'^[0-9]{1,3}-[0-9]{1,3}$'
						when N'Спецвагон'		then N'^[0-9]{3,6}$'
						when N'Полувагон'		then N'^[0-9]{8}$'
						when N'Цистерна'		then N'^[0-9]{8}$'
					end
from [dbo].[PackagingClassProperty] PCP
join [dbo].[PackagingClass] PC
on PCP.[PackagingClassID] = PC.[ID]
where PCP.[Description] = N'Wagon number template'

GO