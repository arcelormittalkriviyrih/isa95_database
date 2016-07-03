SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintTemplate', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintTemplate];
GO

CREATE VIEW [dbo].[v_PrintTemplate]
AS
SELECT NEWID() ID,
       N'MaterialLotProperty' [TypeProperty],
       mcp.[Value] AS [PropertyCode],
       mcp.[Description],
       NULL AS [Value]
FROM dbo.PropertyTypes mcp
UNION ALL
SELECT NEWID() ID,
       N'Weight' [TypeProperty],
       N'WEIGHT' [PropertyCode],
       N'МАССА' [Description],
       NULL AS [Value]
UNION ALL
SELECT NEWID() ID,
       N'FactoryNumber' [TypeProperty],
       N'FactoryNumber' [PropertyCode],
       N'№ бирки для штрих-кода' [Description],
       NULL AS [Value];

GO