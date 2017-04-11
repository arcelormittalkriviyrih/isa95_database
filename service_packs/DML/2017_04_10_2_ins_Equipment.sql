/*insert [Equipment] of ConvShop Process Cell*/
insert into [Equipment]
([Description],[EquipmentLevel],[Equipment],[EquipmentClassID])
Select
	 [Description]
	,[EquipmentLevel]
	,[Equipment]
	,[EquipmentClassID]
from
(
	select N'Шихтовое отделение №1' [Description]
	union all
	select N'Шихтовое отделение №2') as T1
join
(
	select top 1 
		 ID [Equipment]
	from [Equipment] 
	where [Description] = N'Конверторный цех') as T2
on 1=1
join
(
	select top 1
		 ID [EquipmentClassID]
		,[EquipmentLevel]
	from [dbo].[EquipmentClass]
	where [Description] = N'Производственный участок') as T3
on 1=1
