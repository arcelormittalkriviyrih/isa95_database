
/* insert into Packaging Class new transport types*/
merge into [dbo].[PackagingClass] as trg
using (
	select
		 T.[Description]
		,PC.[ID]			as [ParentID]
	from (values
		 (N'Вагон УЗ')
		,(N'Вагон местный')
	) as T([Description])
	cross apply (
		select *
		from [dbo].[PackagingClass]
		where [Description] = N'ЖД вагоны'
	) as PC
	union all 
	select
		 G.[Description]
		,null 
	from (values
		 (N'Автомобильный транспорт')
	) as G([Description])
) as src
on src.[Description] = trg.[Description] and isnull(src.[ParentID], 0) = isnull(trg.[ParentID], 0)
when not matched then
insert ([Description], [ParentID])
values(src.[Description], src.[ParentID])
-- output
	 -- inserted.[ID]
	-- ,inserted.[Description]
	-- ,inserted.[ParentID]
;

merge into [dbo].[PackagingClass] as trg
using (
	select
		 T.[Description]
		,PC.[ID]			as [ParentID]
	from (values
		 (N'Автомобиль')
	) as T([Description])
	cross apply (
		select *
		from [dbo].[PackagingClass]
		where [Description] = N'Автомобильный транспорт'
	) as PC
) as src
on src.[Description] = trg.[Description] and isnull(src.[ParentID], 0) = isnull(trg.[ParentID], 0)
when not matched then
insert ([Description], [ParentID])
values(src.[Description], src.[ParentID])
-- output
	 -- inserted.[ID]
	-- ,inserted.[Description]
	-- ,inserted.[ParentID]
;

GO