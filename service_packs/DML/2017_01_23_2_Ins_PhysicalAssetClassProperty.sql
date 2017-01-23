SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Author: Timur Kapalov
Description: Создание свойств для подклассов класса "Датчик"
*/

; -- select all children of 'Датчик'
WITH tree (ID, ParentID, level, [Description], rn) as 
(
   SELECT ID, [ParentID], 0 as level, [Description],
       convert(varchar(max),right(row_number() over (order by id),10)) rn
   FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[PhysicalAssetClass]
   WHERE [ParentID] is null
   and [Description] = N'Датчики'

   UNION ALL

   SELECT c2.ID, c2.[ParentID], tree.level + 1, c2.[Description], 
       rn + '/' + convert(varchar(max),right(row_number() over (order by tree.ID),10))
   FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[PhysicalAssetClass] c2 
     INNER JOIN tree ON tree.ID = c2.[ParentID]
)

INSERT INTO [dbo].[PhysicalAssetClassProperty]
	([Description]
	,[Value]
	,[PhysicalAssetClassID])

SELECT
	PACP.[Description],
	PACP.[Value],
	t.ID
FROM tree t
join
( 
select N'Модель'				[Description],	N'' [Value]
union all
select N'Серийный номер'		[Description],	N'' [Value]
union all
select N'Класс точности'		[Description],	N'' [Value]
union all
select N'Диапазон измерения'	[Description],	N'' [Value]
union all
select N'Выходной сигнал'		[Description],	N'' [Value]
union all
select N'Период поверки'		[Description],	N'' [Value]
union all
select N'Вид метрологического обеспечения' [Description],N'' [Value]
union all
select N'Статус'				[Description],	N'' [Value]
) as PACP
on 1=1
order by RN


GO
