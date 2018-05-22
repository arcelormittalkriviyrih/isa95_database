/* Properties of Waybills */
insert into [dbo].[DocumentationsClassProperty]
		( [Description],	[DocumentationsClassID])
select T1.[Description], T2.[DocumentationsClassID]
from(
select N'Использован в отвесной'	[Description]
union all
select N'Вес в отвесной'			[Description]
) as T1
join	
(	select ID					[DocumentationsClassID]
	from [dbo].[DocumentationsClass] 
	where [Description] = N'Путевая') as T2
on 1=1

GO