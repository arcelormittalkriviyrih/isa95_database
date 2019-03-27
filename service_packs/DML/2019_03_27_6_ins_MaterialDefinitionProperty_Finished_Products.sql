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
		(N'Известь негашенная И-1', N'Готовая продукция') ,(N'Металлопрокат', N'Готовая продукция') 
		,(N'Азот газообразный и жидкий', N'Готовая продукция') ,(N'Аргон газообразный и жидкий', N'Готовая продукция') 
		,(N'Кислород жидкий технический', N'Готовая продукция') ,(N'Криптоноксеноновая смесь', N'Готовая продукция') 
		,(N'Гелиево-неоновая смесь газообразная сжатая', N'Готовая продукция') ,(N'Шлаки доменные гранулированные', N'Готовая продукция') 
		,(N'Известь негашеная И-2', N'Готовая продукция') ,(N'Масло моторное М-14В2', N'Готовая продукция') 
		,(N'Серная кислота технологичная', N'Готовая продукция') 		
) as T([Description], [ParentDescription])

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