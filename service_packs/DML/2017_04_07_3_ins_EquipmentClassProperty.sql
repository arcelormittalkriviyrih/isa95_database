SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO
/*add new class properties*/

/*
insert into [dbo].[EquipmentClassProperty]
([Description],[Value],[EquipmentClassID])
values
(N'Грузоотправитель',N'CONSIGNER',(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха')),
(N'Грузополучатель' ,N'CONSIGNEE',(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха'))
*/


-- merge because of checking duplicates
merge [dbo].[EquipmentClassProperty] as trg
using(
	select [Description],[Value],[EquipmentClassID]
	from (values
		(N'Грузоотправитель',N'CONSIGNER',(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха')),
		(N'Грузополучатель' ,N'CONSIGNEE',(select top 1 ID from [dbo].[EquipmentClass] where [Description] = N'Цеха'))
	)as T ([Description],[Value],[EquipmentClassID])
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
	,[EquipmentClassID])
	VALUES  
	(src.[Description]
	,src.[Value]
	,src.[EquipmentClassID])
--OUTPUT 
--    $ACTION, 
--    ISNULL(INSERTED.[Description], DELETED.[Description]) AS [Description],
--    ISNULL(INSERTED.[Value], DELETED.[Value]) AS [Value],
--    ISNULL(INSERTED.[EquipmentClassID], DELETED.[EquipmentClassID]) AS [EquipmentClassID]
;

GO