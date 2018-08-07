/* insert [EquipmentProperty] new property SAP_CODE for Areas and Process Cells */
insert into [dbo].[EquipmentProperty]
(EP.[Description]
,EP.[Value]
,EP.[EquipmentID]
,EP.[ClassPropertyID]
)
select 
	 P.[Description]
	,T.[SAPCode]
	,E.[ID]	as [EquipmentID]
	,P.[ID]	as [ClassPropertyID]
from [dbo].[Equipment] E
join (values
 (N'0811',	N'МС 250-1')
,(N'0812',	N'МС 250-2')
,(N'0813',	N'МС 250-3')
,(N'0814',	N'ПС 150-1')
,(N'081',	N'СПЦ-1')
,(N'0821',	N'МС 250-4')
,(N'0822',	N'МС 250-5')
,(N'082',	N'СПЦ-2')
,(N'083',	N'ПЦ-3')
,(N'0831',	N'МС 6')
,(N'0832',	N'ПС 6 (ПУ 8)')
,(N'0832',	N'ПС 6')
,(N'125',	N'ЦПМ')

,(N'722N',	N'Блюминг 1')
,(N'722N',	N'Бл_1250')
,(N'721N',	N'Блюминг 2')
,(N'721N',	N'Бл_1300')

--,(N'0721',	N'Мет.ст1300на1250')
--,(N'0722',	N'Мет.ст1250на1300')
--,(N'721P',	N'УПЗ ПЦ№3 заг1300')
--,(N'722P',	N'УПЗ ПЦ№3 заг1250')
--,(N'072',	N'Блуминг')
) as T([SAPCode], [Shop])
on E.[Description] = T.[Shop]
outer apply (
	select top 1 
		 [ID]
		,[Description] 
	from [dbo].[EquipmentClassProperty] EC 
	where EC.[Value] = N'SAP_CODE') as P
where P.[Description] is not null


