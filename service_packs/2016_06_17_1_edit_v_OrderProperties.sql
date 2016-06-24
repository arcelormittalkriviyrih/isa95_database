SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_OrderPropertiesAll', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderPropertiesAll;
GO

CREATE VIEW [dbo].[v_OrderPropertiesAll]
AS
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       sr.OperationsRequest,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
GO

IF OBJECT_ID ('dbo.v_WorkDefinitionPropertiesAll', N'V') IS NOT NULL
   DROP VIEW dbo.v_WorkDefinitionPropertiesAll;
GO

CREATE VIEW [dbo].[v_WorkDefinitionPropertiesAll]
AS
SELECT ps.[ID],
       pt.[Description],
       ps.[Value],
       pso.[Value] comm_order,
       ps.[WorkDefinitionID],
       pt.[Value] Property
FROM [dbo].[ParameterSpecification] ps
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
     INNER JOIN [dbo].[v_ParameterSpecification_Order] pso ON (pso.WorkDefinitionID=ps.[WorkDefinitionID])
UNION ALL
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       spo.[Value] comm_order,
       NULL,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
     INNER JOIN [dbo].[v_SegmentParameter_Order] spo ON (spo.OpSegmentRequirement=sp.OpSegmentRequirement)
WHERE NOT EXISTS (SELECT NULL 
                  FROM [dbo].[v_ParameterSpecification_Order] pso 
                  WHERE (spo.[Value]=pso.[Value]))
GO

IF OBJECT_ID ('dbo.v_OrderProperties', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderProperties;
GO

CREATE VIEW [dbo].[v_OrderProperties]
AS
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       sr.OperationsRequest,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType AND pt.[Value] IN ('PROD_ORDER','SIZE','LENGTH','TOLERANCE','CLASS','STEEL_CLASS','MELT_NO','PART_NO','MIN_ROD','BUYER_ORDER_NO','BRIGADE_NO','PROD_DATE','UTVK','LEAVE_NO','MATERIAL_NO','BUNT_DIA','PRODUCT','STANDARD','CHEM_ANALYSIS'))
GO


