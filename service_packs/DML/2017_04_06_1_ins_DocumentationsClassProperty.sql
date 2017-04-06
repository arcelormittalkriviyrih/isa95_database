/* Properties of Waybills */
insert into [dbo].[DocumentationsClassProperty]
		( [Description],	[DocumentationsClassID])
select T1.[Description], T2.[DocumentationsClassID]
from(
select N'Номер путевой'			[Description]
union all
select N'Приемосдатчик'			[Description]
union all
select N'Цех отправления'		[Description]
union all
select N'Место погрузки'		[Description]
union all
select N'Цех получения'			[Description]
union all
select N'Место выгрузки'		[Description]
union all
select N'Род вагона'			[Description]
union all
select N'Род груза'				[Description]
union all
select N'Станция отправления'	[Description]
union all
select N'Станция назначения'	[Description]
) as T1
join	
(	select ID					[DocumentationsClassID]
	from [dbo].[DocumentationsClass] 
	where [Description] = N'Путевая') as T2
on 1=1

/* Properties of Weightsheets */
insert into [dbo].[DocumentationsClassProperty]
		( [Description],	[DocumentationsClassID])
select T1.[Description], T2.[DocumentationsClassID]
from(
select N'Номер отвесной'		[Description]
union all
select N'Весовщик'				[Description]
union all
select N'Весы'					[Description]
) as T1
join	
(	select ID					[DocumentationsClassID]
	from [dbo].[DocumentationsClass] 
	where [Description] = N'Отвесная') as T2
on 1=1
