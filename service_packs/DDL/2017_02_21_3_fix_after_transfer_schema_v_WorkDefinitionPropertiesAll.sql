
IF OBJECT_ID (N'dbo.v_WorkDefinitionPropertiesAll', N'V') IS NOT NULL
   DROP VIEW [dbo].[v_WorkDefinitionPropertiesAll];
GO

--| for test scheme
declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = '';

IF OBJECT_ID ('dbo.ParameterSpecification', 'U') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';


SET @query = N'
CREATE VIEW [dbo].[v_WorkDefinitionPropertiesAll]
AS
SELECT ps.[ID],
       pt.[Description],
       ps.[Value],
       pso.[Value] comm_order,
       es.[EquipmentID],
       ps.[WorkDefinitionID],
       pt.[Value] Property
FROM '+@name_scheme+'.[ParameterSpecification] ps
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
     INNER JOIN [dbo].[v_ParameterSpecification_Order] pso ON (pso.WorkDefinitionID=ps.[WorkDefinitionID])
     INNER JOIN [dbo].[OpEquipmentSpecification] es ON (es.[WorkDefinition]=ps.[WorkDefinitionID])
UNION ALL
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       spo.[Value] comm_order,
       eq.[ID] [EquipmentID],
       NULL,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
     INNER JOIN [dbo].[v_SegmentParameter_Order] spo ON (spo.OpSegmentRequirement=sp.OpSegmentRequirement)
     CROSS JOIN [dbo].[Equipment] eq
WHERE NOT EXISTS (SELECT NULL 
                  FROM [dbo].[v_ParameterSpecification_Order] pso 
                  WHERE (pso.[Value]=spo.[Value])
                    AND (pso.[EquipmentID]=eq.[ID]));'

exec(@query);
GO
