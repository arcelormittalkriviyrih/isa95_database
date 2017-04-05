
insert into [dbo].[DocumentationsClass]
	([Description], [ParentID])
values
	(N'Путевая', null),
	(N'Отвесная', null)


insert into [dbo].[DocumentationsClass]
	([Description], [ParentID])
select 
	 T1.[Description]
	,T2.ID
from(
	select N'Тарирование'	[Description]
	union all
	select N'Загрузка'		[Description]
	union all
	select N'Отгрузка'		[Description]
	union all
	select N'Контроль брутто' [Description]) as T1
join(
	select [ID]
	from [dbo].[DocumentationsClass]
	where [Description] = N'Отвесная') as T2
on 1=1
