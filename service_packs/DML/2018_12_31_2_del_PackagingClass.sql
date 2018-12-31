
/* delete from Packaging Class some wagon types and their properties */

delete PCP
from [dbo].[PackagingClassProperty] PCP
join [dbo].[PackagingClass] PC
on PCP.[PackagingClassID] = PC.[ID]
where PC.[Description] in 
(N'Полувагон УЗ'
,N'Спецвагон'
,N'Цистерна УЗ'
,N'Платформа'
,N'Платформа УЗ')

delete
from [dbo].[PackagingClass]
where [Description] in 
(N'Полувагон УЗ'
,N'Спецвагон'
,N'Цистерна УЗ'
,N'Платформа'
,N'Платформа УЗ')

GO