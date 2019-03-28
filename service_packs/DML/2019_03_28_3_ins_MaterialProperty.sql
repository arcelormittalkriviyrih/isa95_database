

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO


--insert MaterialClassProperty

		merge [dbo].[MaterialClassProperty] as trg 
		using
		(select distinct
				 N'В использовании'				as [Description]
				,N'IN_USE'			as [Value]
				,isnull(MC.ID, MD.[MaterialClassID])	as [MaterialClassID]
			from (values  (N'Лом')	) as T([MaterialClassDescription])
			left join [MaterialClass] MC
			on T.[MaterialClassDescription] = MC.[Description]
			left join [dbo].[MaterialDefinition] MD
			on MD.[Description] = T.[MaterialClassDescription]
		where isnull(MC.ID, MD.[MaterialClassID]) is not null) as t2
		on (trg.[MaterialClassID]=t2.[MaterialClassID] and trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] )
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[MaterialClassID]) VALUES (t2.[Description], t2.[Value], t2.[MaterialClassID]);


--insert MaterialDefinitionProperty
		merge [dbo].[MaterialDefinitionProperty] as trg 
		using
		(SELECT  mcp.[Value] [Description], 1  [Value]  , md.[ID]  [MaterialDefinitionID], mcp.[id] [ClassPropertyID]
		  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialClass] mc
		   join [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialClassProperty] mcp
		  on mc.[ID]  = mcp.[MaterialClassID]
		   join [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialDefinition] md
		  on mcp.[MaterialClassID]  =  md.[MaterialClassID]
		  where mc.[Description] = N'Лом'  and mcp.[Value] = N'IN_USE' and md.[MaterialDefinitionID] is not Null) as t2
		on (trg.[Description]=t2.[Description]  and trg.[MaterialDefinitionID]=t2.[MaterialDefinitionID] 
				and trg.[ClassPropertyID]=t2.[ClassPropertyID] )
		WHEN NOT MATCHED THEN
		INSERT ([Description],[Value],[MaterialDefinitionID],[ClassPropertyID]) VALUES (t2.[Description], t2.[Value], t2.[MaterialDefinitionID],t2.[ClassPropertyID]);


GO




