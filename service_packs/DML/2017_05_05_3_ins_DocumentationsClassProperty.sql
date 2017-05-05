/* Properties of Waybills */
insert into [dbo].[DocumentationsClassProperty]
		( [Description],	[DocumentationsClassID])
select T1.[Description], T2.[DocumentationsClassID]
from(
select N'Время прибытия (станция отправления)'				[Description]
union all
select N'Время подачи под погрузку (станция отправления)'	[Description]
union all
select N'Время окончания выгрузки (станция отправления)'	[Description]
union all
select N'Время прибытия (станция получения)'				[Description]
union all
select N'Время подачи под погрузку (станция получения)'		[Description]
union all
select N'Время окончания выгрузки (станция получения)'		[Description]
) as T1
join	
(	select ID					[DocumentationsClassID]
	from [dbo].[DocumentationsClass] 
	where [Description] = N'Путевая') as T2
on 1=1

GO