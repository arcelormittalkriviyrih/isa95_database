USE [KRR-PA-ISA95_PRODUCTION]
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON
GO

 UPDATE [dbo].[MaterialDefinitionProperty]
 SET [Value] = N'140000303'
 WHERE [MaterialDefinitionID] = (SELECT TOP 1 [ID] from [dbo].[MaterialDefinition] where [Description] = N'Брак-скрап')
 and [ClassPropertyID] = (
	SELECT TOP 1 t1.ID
	FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialClassProperty] as t1
	LEFT JOIN [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialClass] as t2
	ON t1.[MaterialClassID] = t2.[ID]
	WHERE t2.[Description] = N'Лом' and t1.[Value] = N'SAP_CODE'
 )

GO
