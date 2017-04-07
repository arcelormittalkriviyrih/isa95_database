SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*add properties for some Process Cell*/
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
join [dbo].[Equipment] as EE
on E.[Equipment] = EE.ID
where ECP.[Description] in (N'ЖД станция')
and  E.EquipmentLevel = 'Process Cell'
and EE.Description = N'ЖДЦ'

GO