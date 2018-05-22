INSERT INTO [dbo].[PackagingClass]  ([Description]  ,[ParentID])
select T.[Description], PC.[ID]
from (VALUES	
	( N'Платформа'),
	( N'Платформа УЗ')
) as T([Description])
join [dbo].[PackagingClass] PC
on 1=1
where PC.[Description] = N'ЖД вагоны'