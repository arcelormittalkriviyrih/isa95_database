IF OBJECT_ID ('dbo.v_OrderPropertiesAll', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_OrderPropertiesAll];
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
           AND pt.[Value] IN('STD', 'LEN', 'QMIN', 'PROD', 'CLASS', 'STCLASS', 'CHEM', 'DIAM', 'ADR', 'CONTR', 'DIR', 'ORDER','TEMPLATE')		   
     UNION ALL
     SELECT mr.id,
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
