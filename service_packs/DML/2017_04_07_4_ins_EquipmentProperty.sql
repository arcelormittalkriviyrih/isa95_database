/*add properties for Areas*/
insert into [dbo].[EquipmentProperty]
([Description],[Value],[EquipmentID],[ClassPropertyID])
select
	 ECP.[Description]
	,'true' as [Value]
	,E.ID
	,ECP.[ID]
from [dbo].[EquipmentClassProperty] ECP
join [dbo].[Equipment] as E
on 1=1 
where ECP.[Description] in (N'Грузоотправитель', N'Грузополучатель')
and  E.EquipmentLevel = 'Area'