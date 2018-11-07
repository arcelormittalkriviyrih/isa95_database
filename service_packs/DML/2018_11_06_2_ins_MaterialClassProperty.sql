SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

--insert MaterialClassProperty
insert into [dbo].[MaterialClassProperty]
	([Description]
	,[Value]
	,[MaterialClassID])
select distinct
	 N'Код SAP'				as [Description]
	,N'SAP_CODE'			as [Value]
	,isnull(MC.ID, MD.[MaterialClassID])	as [MaterialClassID]
from (values 
	 (N'Готовая продукция')
	,(N'Сырье')
	,(N'Оборотный лом')
	,(N'Чугунный лом')
) as T([MaterialClassDescription])
left join [MaterialClass] MC
on T.[MaterialClassDescription] = MC.[Description]
left join [dbo].[MaterialDefinition] MD
on MD.[Description] = T.[MaterialClassDescription]
where isnull(MC.ID, MD.[MaterialClassID]) is not null

GO