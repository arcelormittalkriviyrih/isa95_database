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
where T2.Description in (N'Платформа', N'Платформа УЗ', N'Полувагон УЗ', N'Цистерна УЗ')



/*add new properties for wagons*/
insert into [dbo].[PackagingClassProperty]
([Description], [Value], [ValueUnitofMeasure], [PackagingClassID])
select 
	 N'Wagon number template' as [Description]
	,T.[Value]
	,null as [ValueUnitofMeasure]
	,PC.[ID] as [PackagingClassID]
from (VALUES	
	(N'Полувагон УЗ', N'^[0-9]{8}$'),
	(N'Цистерна УЗ', N'^[0-9]{8}$'),
	(N'Платформа УЗ', N'^[0-9]{8}$'),
	(N'Платформа', N'^[0-9]{3,6}$')
) as T([Description], [Value])
join [dbo].[PackagingClass] PC
on T.[Description] = PC.[Description]

GO