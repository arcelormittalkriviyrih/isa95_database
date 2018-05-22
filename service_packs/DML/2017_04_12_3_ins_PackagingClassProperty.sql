SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*add new properties for wagons*/
insert into [dbo].[PackagingClassProperty]
(Description, [Value], [ValueUnitofMeasure], [PackagingClassID])
select	
	 T1.[Description]
	,T2.[Value]
	,'ton' as [ValueUnitofMeasure]
	,T2.[ID]
from
(select N'Грузоподъемность' [Description]) as T1
join
(
SELECT [ID]
      ,[Description]
      ,[ParentID]
	  ,50 as [Value]
FROM [dbo].[PackagingClass]
) as T2
on 1=1
where T2.Description in (N'Лафет-короб', N'Полувагон', N'Спецвагон', N'Цистерна')


GO