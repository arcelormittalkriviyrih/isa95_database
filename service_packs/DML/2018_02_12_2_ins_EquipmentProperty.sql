
SET QUOTED_IDENTIFIER ON
GO
/* merge [EquipmentProperty] new property SCALES_TYPE for scales 'Весы Копр.№4' */
;with CTE_Platforms as (
select N'{WagonClassID: ' + cast([ID] as nvarchar) + N', Weight: [' + [Platforms] + N']}' as [Platforms]
from (
	select 
		 PC.ID
		,PC.[Description]
		,case PC.[Description]
			when N'Лафет-короб' 
			then N'''Weight_platform_1'''
			else N'''Weight_platform_1'', ''Weight_platform_2'''
		 end	as [Platforms]
	from [dbo].[PackagingClass] PC
	left join [dbo].[PackagingClass] PC1
	on PC.[ParentID] = PC1.[ID]
	where PC1.[Description] = N'ЖД вагоны') as T1
)
, CTE_Platforms_Concat as (
SELECT distinct
	STUFF((
		SELECT ',' + T2.[Platforms] 
		FROM CTE_Platforms AS T2
		FOR XML PATH('')), 1, 1, '') as [PlatformsArray]
FROM CTE_Platforms AS T1
)


merge [dbo].[EquipmentProperty] as trg
using(
select
	 null						as [Description]
	--,N'[{ WagonClassID : 2, Weight : [ ''Weight_platform_1'' ] },{ WagonClassID : 3, Weight : [ ''Weight_platform_1'', ''Weight_platform_2'' ] },{ WagonClassID : 4, Weight : [ ''Weight_platform_1'', ''Weight_platform_2'' ] },{ WagonClassID : 5, Weight : [ ''Weight_platform_1'', ''Weight_platform_2'' ] }]'
	,N'['+[PlatformsArray]+N']'	as [Value]
	,null						as [EquipmentProperty]
	,E.ID						as [EquipmentID]
	,ECP.ID						as [ClassPropertyID]
from [dbo].[Equipment] E
join [dbo].[EquipmentClass] EC
on E.EquipmentClassID = EC.ID
join [dbo].[EquipmentClassProperty] ECP
on ECP.EquipmentClassID = EC.ID
join CTE_Platforms_Concat
on 1=1
where	EC.Code = N'SCALES'
	and E.Description in (N'Весы Копр.№4')
	and ECP.Value = N'WEIGHBRIDGES_PLATFORMS_WAGON_CLASS'
) as src
on	trg.[EquipmentID] = src.[EquipmentID] 
and trg.[ClassPropertyID] = src.[ClassPropertyID] 
and trg.[EquipmentProperty] = src.[EquipmentProperty]
-- если есть сопоставление строки trg со строкой из источника src
WHEN MATCHED THEN 
	UPDATE SET	  
	 trg.[Value] = src.[Value]
-- если строка не найдена в trg, но есть в src
WHEN NOT MATCHED BY TARGET THEN 
    INSERT 
(	 [Description]
	,[Value]
	,[EquipmentProperty]
	,[EquipmentID]
	,[ClassPropertyID])
	VALUES  
(	 src.[Description]
	,src.[Value]
	,src.[EquipmentProperty]
	,src.[EquipmentID]
	,src.[ClassPropertyID]);

GO

SET QUOTED_IDENTIFIER OFF
GO