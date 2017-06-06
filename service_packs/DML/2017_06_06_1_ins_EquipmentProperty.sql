
SET QUOTED_IDENTIFIER ON
GO
/*insert [EquipmentProperty] new property SCALES_TYPE for scales 'Весы Копр.№4'*/
insert into [dbo].[EquipmentProperty] 
(	[Description]
	,[Value]
	,[EquipmentProperty]
	,[EquipmentID]
	,[ClassPropertyID])
select
	 null
	,N'STATIC'
	,null
	,E.ID
	,ECP.ID
from [dbo].[Equipment] E
join [dbo].[EquipmentClass] EC
on E.EquipmentClassID = EC.ID
join [dbo].[EquipmentClassProperty] ECP
on ECP.EquipmentClassID = EC.ID
where	EC.Code = N'SCALES'
	and E.Description in (N'Весы Копр.№4')
	and ECP.Value = N'SCALES_TYPE'

GO

SET QUOTED_IDENTIFIER OFF
GO