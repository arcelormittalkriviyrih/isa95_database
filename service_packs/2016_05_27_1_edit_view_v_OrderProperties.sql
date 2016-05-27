IF OBJECT_ID ('dbo.v_OrderProperties', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_OrderProperties];
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
           AND pt.[Value] IN('STD', 'LED', 'QMIN', 'PROD', 'CLASS', 'STCLASS', 'CHEM', 'DIAM', 'ADR')
     UNION ALL
     SELECT mr.id,
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

