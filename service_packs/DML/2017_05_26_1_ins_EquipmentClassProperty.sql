SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*add new class properties for ProcessCell*/
insert into [dbo].[EquipmentClassProperty]
(	 [Description]
	,[Value]
	,[EquipmentClassProperty]
	,[EquipmentClassID])
select
	 N'ЖД станция по умолчанию' as [Description]
	,N'DEFAULT RAILWAY STATION'	as [Value]
	,null						as [EquipmentClassProperty]
	,EC.ID						as [EquipmentClassID]
from [dbo].[EquipmentClass] EC
where EC.[EquipmentLevel] = N'Process Cell'

GO