SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

/*add properties for some ProcessCell*/
insert into [dbo].[EquipmentProperty]
(	 [Description]
    ,[Value]
	,[EquipmentProperty]
	,[EquipmentID]
	,[ClassPropertyID])
select
	 ECP.[Description]
	,E2.[ID]
	,null
	,E1.[ID]
	,ECP.[ID]
from (values
 (N'Миксерное отделение'		,N'ст. Сталь-2')
,(N'Конвертерное отделение'		,N'ст. Сталь-2')
,(N'Разливочное отделение'		,N'ст. Сталь-2')
,(N'ОНРС'						,N'ст. Сталь-2')
,(N'Шихтовое отделение №1'		,N'ст. Сталь-2')
,(N'Шихтовое отделение №2'		,N'ст. Сталь-2')
,(N'Участок Копр.№4'			,N'ст. Сталь-2')
,(N'Керамет Копр.№4'			,N'ст. Сталь-2')
,(N'ПС 150-1'					,N'ст. Прокатная-1')
,(N'МС 250-1'					,N'ст. Прокатная-1')
,(N'МС 250-2'					,N'ст. Прокатная-1')
,(N'МС 250-3'					,N'ст. Прокатная-1')
,(N'МС 250-4'					,N'ст. Прокатная-1')
,(N'МС 250-5'					,N'ст. Прокатная-1')
,(N'Участок Копр.№1'			,N'ст. Копровая-1')
,(N'Участок Копр.№2'			,N'ст. Копровая-1')
) as T ([Description], [Value])
inner join [dbo].[Equipment] E1
on E1.[Description] = T.[Description]
inner join [dbo].[Equipment] E2
on E2.[Description] = T.[Value]
inner join [dbo].[EquipmentClassProperty] ECP
on 1=1
where ECP.[Value] in (N'DEFAULT RAILWAY STATION')

GO