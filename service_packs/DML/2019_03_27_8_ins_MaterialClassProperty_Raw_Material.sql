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
				 N'Код SAP'				as [Description]
				,N'SAP_CODE'			as [Value]
				,isnull(MC.ID, MD.[MaterialClassID])	as [MaterialClassID]
			from (values  (N'Сырье')	) as T([MaterialClassDescription])
			left join [MaterialClass] MC
			on T.[MaterialClassDescription] = MC.[Description]
			left join [dbo].[MaterialDefinition] MD
			on MD.[Description] = T.[MaterialClassDescription]
		where isnull(MC.ID, MD.[MaterialClassID]) is not null) as t2
		on (trg.[MaterialClassID]=t2.[MaterialClassID] and trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] )
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[MaterialClassID]) VALUES (t2.[Description], t2.[Value], t2.[MaterialClassID]);


		merge [dbo].[MaterialClassProperty] as trg 
		using
		(select distinct
				 N'В использовании'				as [Description]
				,N'IN_USE'			as [Value]
				,isnull(MC.ID, MD.[MaterialClassID])	as [MaterialClassID]
			from (values  (N'Сырье')	) as T([MaterialClassDescription])
			left join [MaterialClass] MC
			on T.[MaterialClassDescription] = MC.[Description]
			left join [dbo].[MaterialDefinition] MD
			on MD.[Description] = T.[MaterialClassDescription]
		where isnull(MC.ID, MD.[MaterialClassID]) is not null) as t2
		on (trg.[MaterialClassID]=t2.[MaterialClassID] and trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] )
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[MaterialClassID]) VALUES (t2.[Description], t2.[Value], t2.[MaterialClassID]);

GO