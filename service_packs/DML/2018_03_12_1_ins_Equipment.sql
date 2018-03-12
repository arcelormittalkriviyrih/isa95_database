/*insert [Equipment] of RollingMill Shop*/
insert into [Equipment]
([Description]
,[Location]
,[EquipmentLevel]
,[Equipment]
,[HierarchyScope]
,[EquipmentClassID])
select
	 T.[Description]
	,null					as [Location]
	,EC.[EquipmentLevel]
	,E.[ID]					as [Equipment]
	,null					as [HierarchyScope]
	,EC.[ID]				as [EquipmentClassID]
from (values
	(N'Склад готовой продукции', N'Производственный участок', N'СПЦ-1')
) as T([Description],[ClassDescription],[ParentDescription])
join [dbo].[Equipment] E
on E.[Description] = T.[ParentDescription]
join [dbo].[EquipmentClass] EC
on EC.[Description] = T.[ClassDescription]
