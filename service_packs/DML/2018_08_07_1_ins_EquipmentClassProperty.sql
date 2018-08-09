/*insert new property  SAP_CODE into [EquipmentClassProperty]*/
insert into [dbo].[EquipmentClassProperty]
([Description]
,[Value]
,[EquipmentClassID])
select 
	 N'Код SAP'		as [Description]
	,N'SAP_CODE'	as [Value]
	,EC.[ID]
from [dbo].[EquipmentClass] EC
where EC.[Description] in (N'Цеха', N'Производственный участок')
