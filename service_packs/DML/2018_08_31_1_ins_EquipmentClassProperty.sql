SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*add new class properties for Scales*/
-- merge because of checking duplicates
merge [dbo].[EquipmentClassProperty] as trg
using(
	select
		 T.[Description]
		,T.[Value]
		,null  as [EquipmentClassProperty]
		,EC.ID as [EquipmentClassID]
	from (values
	 (N'SCALES', N'ZEROING_TAG', N'Тег обнуления')
	,(N'SCALES', N'ZEROING_COMMAND', N'Команда обнуления')) as T([Code], [Value], [Description])
	join [dbo].[EquipmentClass] EC
	on EC.Code=T.[Code]
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