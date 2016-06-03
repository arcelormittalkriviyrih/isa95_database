--тест
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
     FROM dbo.SegmentParameter AS sp,
          dbo.PropertyTypes AS pt,
          dbo.OpSegmentRequirement AS sr
     WHERE pt.ID = sp.PropertyType
           AND sp.OpSegmentRequirement = sr.id
           AND pt.[Value] IN('STANDARD', 'LENGTH', 'MIN_ROD', 'PRODUCT', 'CLASS', 'STEEL_CLASS', 'CHEM_ANALYSIS', 'BUNT_DIA', 'ADDRESS', 'CONTRACT_NO', 'DIRECTION', 'COMM_ORDER','TEMPLATE')		   
     UNION ALL
     SELECT 1000000000+mr.id,
            mc.Description,
            convert(nvarchar, md.ID) AS [Value],
            sr.OperationsRequest,
			'PROFILE' as Property
     FROM dbo.OpMaterialRequirement AS mr,
          dbo.MaterialDefinition AS md,
          dbo.MaterialClass AS mc,
          dbo.OpSegmentRequirement AS sr
     WHERE md.ID = mr.MaterialDefinitionID
           AND mc.ID = md.MaterialClassID
           AND mr.SegmenRequirementID = sr.ID;
GO

IF OBJECT_ID ('dbo.v_OrderProperties', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderProperties;
GO

CREATE VIEW [dbo].[v_OrderProperties]
AS
     SELECT sp.ID,
            pt.Description,
            sp.[Value],
            sr.OperationsRequest
     FROM dbo.SegmentParameter AS sp,
          dbo.PropertyTypes AS pt,
          dbo.OpSegmentRequirement AS sr
     WHERE pt.ID = sp.PropertyType
           AND sp.OpSegmentRequirement = sr.id
           AND pt.[Value] IN('STANDARD', 'LENGTH', 'MIN_ROD', 'PRODUCT', 'CLASS', 'STEEL_CLASS', 'CHEM_ANALYSIS', 'BUNT_DIA', 'ADDRESS')
     UNION ALL
     SELECT 1000000000+mr.id,
            mc.Description,
            md.Description AS [Value],
            sr.OperationsRequest
     FROM dbo.OpMaterialRequirement AS mr,
          dbo.MaterialDefinition AS md,
          dbo.MaterialClass AS mc,
          dbo.OpSegmentRequirement AS sr
     WHERE md.ID = mr.MaterialDefinitionID
           AND mc.ID = md.MaterialClassID
           AND mr.SegmenRequirementID = sr.ID;
GO

IF OBJECT_ID ('dbo.v_Orders', N'V') IS NOT NULL
   DROP VIEW dbo.v_Orders;
GO

CREATE VIEW [dbo].[v_Orders]
AS
select opr.id,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='COMM_ORDER') as COMM_ORDER,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='CONTRACT_NO') as CONTRACT_NO,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='DIRECTION') as DIRECTION,
(select f.Name from SegmentParameter sp, PropertyTypes pt, Files f where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='TEMPLATE' and sp.value=f.ID) as TEMPLATE
from OperationsRequest as opr,
OpSegmentRequirement sr
where opr.ID=sr.OperationsRequest;

GO
