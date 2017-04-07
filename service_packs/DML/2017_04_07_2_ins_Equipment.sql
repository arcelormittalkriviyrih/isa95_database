/*add shop Blooming-2*/
insert into [dbo].[Equipment]
([Description], EquipmentLevel, [Equipment], EquipmentClassID)
select 
	 N'Блюминг-2'
	,N'Area'
	,(select top 1 ID from [dbo].[Equipment] where [Description] = N'Прокатный департамент')
	,(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха')

/*add Railway stations*/
insert into [dbo].[Equipment]
([Description], [EquipmentLevel], [Equipment], [EquipmentClassID])
select 
	 N'ЖДЦ'
	 ,'Area'
	 ,(select top 1 ID from [dbo].[Equipment] where [Description] = N'Транспортный департамент')
	 ,(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха')


insert into [dbo].[Equipment]
([Description], [EquipmentLevel], [Equipment], [EquipmentClassID])
select 
	 T.[Description]
	,N'Process Cell'
	,(select top 1 ID from [dbo].[Equipment] where [Description] = N'ЖДЦ')
	,(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Производственный участок')
from(
select N'ст. Карьерная' [Description]
union all
select N'ст. Погрузочная'
union all
select N'ст. Породная'
union all
select N'ст. Разгрузочная'
union all
select N'ст. Аглофабрика ГОКа'
union all
select N'ст. Промышленная ГОКа'
union all
select N'ст. Южная ГОКа'
union all
select N'ст. Западная'
union all
select N'ст. Заречная'
union all
select N'ст. Заречная-1'
union all
select N'ст. Прокатная-1'
union all
select N'ст. Прокатная-2'
union all
select N'ст. Промышленная'
union all
select N'ст. Складская'
union all
select N'ст. Промежуточная'
union all
select N'ст. Сталь-1'
union all
select N'ст. Сталь-2'
union all
select N'ст. Шихтовая'
union all
select N'ст. Южная'
union all
select N'ст. Восточная-Разгрузочная'
union all
select N'ст. Восточная-Сортировочная'
union all
select N'ст. Доменная'
union all
select N'ст. Кирова'
union all
select N'ст. Коксовая'
union all
select N'ст. Копровая-1'
union all
select N'ст. Копровая-2'
union all
select N'ст. Металлургическая'
union all
select N'ст. Новобункерная'
union all
select N'ст. Новодоменная'
union all
select N'ст. Отвальная'
union all
select N'ст. Аглофабрика'
union all
select N'ст. Бункерная'
union all
select N'ст. Вост.-Приемоотправочная'
) as T
order by [Description]