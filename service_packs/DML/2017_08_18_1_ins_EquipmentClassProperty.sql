SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*add new class properties for ProcessCell*/
/*
insert into [dbo].[EquipmentClassProperty]
(	 [Description]
	,[Value]
	,[EquipmentClassProperty]
	,[EquipmentClassID])
select
	 N'Соответствие платформ и вида вагона'	as [Description]
	,N'WEIGHBRIDGES_PLATFORMS_WAGON_CLASS'	as [Value]
	,null									as [EquipmentClassProperty]
	,EC.ID									as [EquipmentClassID]
from [dbo].[EquipmentClass] EC
where EC.Code = N'SCALES'
*/

-- merge because of checking duplicates
merge [dbo].[EquipmentClassProperty] as trg
using(
	select
		 N'Соответствие платформ и вида вагона'	as [Description]
		,N'WEIGHBRIDGES_PLATFORMS_WAGON_CLASS'	as [Value]
		,null									as [EquipmentClassProperty]
		,EC.ID									as [EquipmentClassID]
	from [dbo].[EquipmentClass] EC
	where EC.Code = N'SCALES'
) as src
on trg.[Description] = src.[Description] and trg.[Value] = src.[Value]
-- если есть сопоставление строки trg со строкой из источника src
WHEN MATCHED THEN 
	UPDATE SET	  
	 trg.[EquipmentClassID] = src.[EquipmentClassID]
-- если строка не найдена в trg, но есть в src
WHEN NOT MATCHED BY TARGET THEN 
    INSERT 
	([Description]
	,[Value]
	,[EquipmentClassProperty]
	,[EquipmentClassID])
	VALUES  
	(src.[Description]
	,src.[Value]
	,src.[EquipmentClassProperty]
	,src.[EquipmentClassID])
--OUTPUT 
--    $ACTION, 
--    ISNULL(INSERTED.[Description], DELETED.[Description]) AS [Description],
--    ISNULL(INSERTED.[Value], DELETED.[Value]) AS [Value],
--    ISNULL(INSERTED.[EquipmentClassID], DELETED.[EquipmentClassID]) AS [EquipmentClassID]
;
GO