SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintTemplate', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintTemplate];
GO

CREATE VIEW [dbo].[v_PrintTemplate]
AS
SELECT newID() ID,
	  N'EquipmentProperty' [TypeProperty],
       ecp.[Value] AS [PropertyCode],
       ecp.[Description],
       NULL AS [Value]
FROM dbo.EquipmentClassProperty ecp
UNION ALL
SELECT newID() ID,
       N'MaterialProperty' [TypeProperty],
       mcp.[Value] AS [PropertyCode],
       mcp.[Description],
       NULL AS [Value]
FROM dbo.MaterialClassProperty mcp
UNION ALL
SELECT newID() ID,
       N'PropertyTypes' [TypeProperty],
       mcp.[Value] AS [PropertyCode],
       mcp.[Description],
       NULL AS [Value]
FROM dbo.PropertyTypes mcp
UNION ALL
SELECT newID() ID,
	  N'PersonnelProperty' [TypeProperty],
       pcp.[Value] AS [PropertyCode],
       pcp.[Description],
       NULL AS [Value]
FROM dbo.PersonnelClassProperty pcp;

GO