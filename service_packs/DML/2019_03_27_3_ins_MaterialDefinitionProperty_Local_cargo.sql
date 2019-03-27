SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO


select
	 [Description]
	,[ParentDescription]
into #tmp_mat
from (values
		(N'Бой бетона', N'Местные грузы') ,(N'Промасленные опилки', N'Местные грузы') ,(N'Серная кислота', N'Местные грузы')
		,(N'Тара ГСМ (бочки, цистерна, ведро)', N'Местные грузы') ,(N'Б/у автошины', N'Местные грузы')
		,(N'Теплоизолирующая смесь', N'Местные грузы') ,(N'Отходы древесины', N'Местные грузы') ,(N'Ветошь', N'Местные грузы')
		,(N'Отходы формовочной смеси', N'Местные грузы') ,(N'Пыль литейного двора', N'Местные грузы')
		,(N'Отходы паронита', N'Местные грузы')	,(N'Зольная смесь', N'Местные грузы') ,(N'Цемент', N'Местные грузы')
		,(N'Шлам от проп.цистерн', N'Местные грузы') ,(N'Легко воспламеняющая  жидкость', N'Местные грузы')
		,(N'Отходы теплоизоляции', N'Местные грузы') ,(N'Твердые бытовые отходы', N'Местные грузы')	,(N'Масло моторное', N'Местные грузы')
		,(N'Лом динасовый', N'Местные грузы') ,(N'Пыль абразивно-метал.', N'Местные грузы')	,(N'Шлам мойки машин', N'Местные грузы')
		,(N'Замасленный песок', N'Местные грузы') ,(N'Б/у шпала деревянная', N'Местные грузы') ,(N'Изоляторы керам.отраб.', N'Местные грузы')
		,(N'Отходы гаш.извести', N'Местные грузы') ,(N'Металлолом', N'Местные грузы') ,(N'Шлам градирен', N'Местные грузы')
		,(N'Отходы упак.материалов', N'Местные грузы') ,(N'Шлак дом.отвальный', N'Местные грузы') ,(N'Сетка тип 4', N'Местные грузы')
		,(N'Аспирационная пыль', N'Местные грузы') ,(N'Металлосодержащая пыль', N'Местные грузы') ,(N'Отработ.фильтра', N'Местные грузы')
		,(N'Масло трансформаторное', N'Местные грузы') ,(N'Шлам', N'Местные грузы')	,(N'Щебень', N'Местные грузы')
		,(N'Отработ.масло', N'Местные грузы') ,(N'Сальник', N'Местные грузы') ,(N'Шлам железосодержащий', N'Местные грузы')
		,(N'Ил активный избыт.', N'Местные грузы') ,(N'Шлак флюсовый', N'Местные грузы') ,(N'Стеклобой', N'Местные грузы')
		,(N'РТИ отходы', N'Местные грузы') ,(N'Швелер', N'Местные грузы') ,(N'Сталь', N'Местные грузы')	,(N'Шлам химический', N'Местные грузы')
		,(N'Песок речной', N'Местные грузы') ,(N'Фусы с мех.осветлителей', N'Местные грузы') ,(N'Бой кирпича', N'Местные грузы')
		,(N'Отходы нейтрализации кислоты', N'Местные грузы') ,(N'Угольный концентрат', N'Местные грузы') ,(N'Смесь СГШ', N'Местные грузы')
		,(N'Поддон деревянный', N'Местные грузы') ,(N'Беговая дорожка', N'Местные грузы') ,(N'Рейки', N'Местные грузы')
		,(N'Огнеупорный лом (огнелом)', N'Местные грузы') ,(N'Смесь для керам.наплавки', N'Местные грузы')
		,(N'Поддон металлический', N'Местные грузы') ,(N'Сажа котлоагрегатов', N'Местные грузы') ,(N'Лист н/ж', N'Местные грузы')
		,(N'Асфаль', N'Местные грузы') ,(N'Отходы эвтектической соли', N'Местные грузы') ,(N'Абсорбенты', N'Местные грузы')
		,(N'Тара лакокрасочных материалов (ЛКМ)', N'Местные грузы')	,(N'Магнезиальный лом', N'Местные грузы')
		,(N'Пр.лист', N'Местные грузы')	,(N'Материалы резиновые отработанные', N'Местные грузы') ,(N'Кабеле-проводниковая продукция', N'Местные грузы')
		,(N'Труба', N'Местные грузы') ,(N'Макулатура', N'Местные грузы') ,(N'Опалубка', N'Местные грузы') ,(N'Паронит', N'Местные грузы')
		,(N'Электрооборудование', N'Местные грузы') ,(N'Отходы тары от лакокрасочных материалов', N'Местные грузы')
		,(N'Отходы термоизоляции', N'Местные грузы') ,(N'Шпалы б/у деревянные', N'Местные грузы') ,(N'Строительные отходы', N'Местные грузы')
		,(N'Отходы', N'Местные грузы') ,(N'Утиль', N'Местные грузы') ,(N'Отходы паронит. прокл.', N'Местные грузы')	,(N'Нерж. металлолом', N'Местные грузы')
) as T([Description], [ParentDescription])

-- drop table #tmp_mat

-- insert without ID 
 		merge [dbo].[MaterialDefinition]  as trg 
		using
		(select	 T.[Description] as [Description]
				,1 				as [HierarchyScope]
				,isnull(MC.[ID], MD1.[MaterialClassID])			as [MaterialClassID]
			from #tmp_mat as T
			left join [dbo].[MaterialClass] MC
			on T.[ParentDescription] = MC.[Description]
			left join [dbo].[MaterialDefinition] MD1
			on MD1.[Description] = T.[ParentDescription]
			where isnull(MC.[ID], MD1.[MaterialClassID]) is not null) as t2
		on (trg.[Description]=t2.[Description] and trg.[HierarchyScope]=t2.[HierarchyScope] and trg.[MaterialClassID]=t2.[MaterialClassID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [HierarchyScope] ,[MaterialClassID]) VALUES (t2.[Description], t2.[HierarchyScope], t2.[MaterialClassID]);


--insert MaterialDefinitionProperty
 		merge [dbo].[MaterialDefinitionProperty]  as trg 
		using
		(select distinct
				 MCP.[Value]					as [Description]
				,N''							as [Value]
				,MD.[ID]						as [MaterialDefinitionID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[MaterialDefinition] MD
			join #tmp_mat as T
			on MD.[Description] = T.[Description]
			join [dbo].[MaterialClassProperty] MCP
			on MCP.[MaterialClassID] = MD.[MaterialClassID]
			where MCP.[Value] = N'SAP_CODE') as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[MaterialDefinitionID]=t2.[MaterialDefinitionID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[MaterialDefinitionID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[MaterialDefinitionID] ,t2.[ClassPropertyID]);

--insert MaterialDefinitionProperty_IN_USE
 		merge [dbo].[MaterialDefinitionProperty]  as trg 
		using
		(select distinct
				 MCP.[Value]					as [Description]
				,N'1'							as [Value]
				,MD.[ID]						as [MaterialDefinitionID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[MaterialDefinition] MD
			join #tmp_mat as T
			on MD.[Description] = T.[Description]
			join [dbo].[MaterialClassProperty] MCP
			on MCP.[MaterialClassID] = MD.[MaterialClassID]
			where MCP.[Value] = N'IN_USE') as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[MaterialDefinitionID]=t2.[MaterialDefinitionID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[MaterialDefinitionID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[MaterialDefinitionID] ,t2.[ClassPropertyID]);

GO