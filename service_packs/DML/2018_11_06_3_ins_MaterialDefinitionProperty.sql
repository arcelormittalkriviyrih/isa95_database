SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO


select
	 [ID]
	,[Description]
	,[ParentDescription]
into #tmp_mat
from (values
	 (93		,N'Арматура в мотках до 1100-2100 кг', N'Готовая продукция')
	,(91		,N'Арматура в мотках до 600 кг', N'Готовая продукция')
	,(94		,N'Арматура в прутках', N'Готовая продукция')
	,(6806		,N'Гвозди', N'Готовая продукция')
	,(103		,N'Заготовка', N'Оборотный лом')
	,(102254	,N'Изделия металлические', N'Оборотный лом')
	,(96		,N'Катанка в мотках до 1100-2100 кг', N'Готовая продукция')
	,(95		,N'Катанка в мотках до 600 кг', N'Готовая продукция')
	,(102		,N'Квадрат', N'Готовая продукция')
	,(97		,N'Круг в мотках', N'Готовая продукция')
	,(98		,N'Круг в прутках', N'Готовая продукция')
	,(1092		,N'Наборы в мотках арматур. и круг. профил.', N'Готовая продукция')
	,(959		,N'Наборы в мотках катанки', N'Готовая продукция')
	,(958		,N'Наборы в прутках арматурного профиля', N'Готовая продукция')
	,(1088		,N'Наборы в прутках квадратного профиля', N'Готовая продукция')
	,(1089		,N'Наборы в прутках круглого профиля', N'Готовая продукция')
	,(1091		,N'Наборы в прутках полосового профиля', N'Готовая продукция')
	,(1090		,N'Наборы в прутках углового профиля', N'Готовая продукция')
	,(130		,N'Орешек коксовый', N'Сырье')
	,(101		,N'Полоса', N'Готовая продукция')
	,(960		,N'Проволока', N'Готовая продукция')
	,(961		,N'Проволока марка', N'Готовая продукция')
	,(128		,N'Прокат хоз.назначения арматура в мотках', N'Готовая продукция')
	,(127		,N'Прокат хоз.назначения арматура в прутках', N'Готовая продукция')
	,(14535		,N'Прокат хоз.назначения катанка 1100-2100', N'Готовая продукция')
	,(1180		,N'Прокат хоз.назначения катанка 550', N'Готовая продукция')
	,(108		,N'Прокат хоз.назначения квадрат', N'Готовая продукция')
	,(107		,N'Прокат хоз.назначения круг', N'Готовая продукция')
	,(110		,N'Прокат хоз.назначения полоса', N'Готовая продукция')
	,(109		,N'Прокат хоз.назначения уголок', N'Готовая продукция')
	,(131		,N'Смола', N'Готовая продукция')
	,(99		,N'Уголок', N'Готовая продукция')
	,(100		,N'Уголок в замок', N'Готовая продукция')
	,(105		,N'Чугун литейный', N'Чугунный лом')
	,(104		,N'Чугун передельный', N'Чугунный лом')
	,(106		,N'Чугун рафинированный', N'Чугунный лом')
	,(126		,N'Шестигранник', N'Готовая продукция')

	,(6113		,N'Смола каменноугольная В', N'Готовая продукция')
	,(6439		,N'Бензол сырой каменноугольный БС', N'Готовая продукция')
	,(6114		,N'Смола тяж.кислой смол.для дор.СТУ-2', N'Готовая продукция')
	,(16844		,N'Аммония сульфат КХП, насыпью', N'Готовая продукция')
	,(355		,N'Полимеры бензольных отделений', N'Готовая продукция')
) as T([ID],[Description], [ParentDescription])


-- insert with ID (origin ID exists)
insert into [dbo].[MaterialDefinition] 
	([Description]
	,[HierarchyScope]
	,[MaterialClassID]
	,[MaterialDefinitionID])
select
	 T.[Description]								as [Description]
	,1												as [HierarchyScope]
	,isnull(MC.[ID], MD1.[MaterialClassID])			as [MaterialClassID]
	,MD1.ID											as [MaterialDefinitionID]
from #tmp_mat as T
left join [dbo].[MaterialDefinition] MD
on MD.[ID] = T.[ID]
left join [dbo].[MaterialClass] MC
on T.[ParentDescription] = MC.[Description]
left join [dbo].[MaterialDefinition] MD1
on MD1.[Description] = T.[ParentDescription]

where isnull(MC.[ID], MD1.[MaterialClassID]) is not null


--insert MaterialDefinitionProperty
insert into [dbo].[MaterialDefinitionProperty] 
	([Description]
	,[Value]
	,[MaterialDefinitionID]
	,[ClassPropertyID])
select distinct
	 MCP.[Value]					as [Description]
	,T.[ID]							as [Value]
	,MD.[ID]						as [MaterialDefinitionID]
	,MCP.[ID]						as [ClassPropertyID]

from [dbo].[MaterialDefinition] MD
join #tmp_mat as T
on MD.[Description] = T.[Description]
join [dbo].[MaterialClassProperty] MCP
on MCP.[MaterialClassID] = MD.[MaterialClassID]
where MCP.[Value] = N'SAP_CODE'

GO