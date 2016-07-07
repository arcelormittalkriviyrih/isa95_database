SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintTemplate', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintTemplate];
GO

CREATE VIEW [dbo].[v_PrintTemplate]
AS
SELECT NEWID() AS ID,
       N'MaterialLotProperty' AS TypeProperty,
       mcp.[Value] AS PropertyCode,
       mcp.Description,
       NULL AS [Value]
FROM dbo.PropertyTypes AS mcp
WHERE mcp.[Value] IN(N'STANDARD', N'LENGTH', N'MIN_ROD', N'CONTRACT_NO', N'DIRECTION', N'PRODUCT', N'CLASS', N'STEEL_CLASS', N'CHEM_ANALYSIS', N'BUNT_DIA', N'ADDRESS', N'PROD_ORDER', N'PROD_DATE', N'MELT_NO', N'PART_NO', N'BUNT_NO', N'LEAVE_NO', N'CHANGE_NO', N'BRIGADE_NO', N'SIZE', N'TOLERANCE', N'BUYER_ORDER_NO', N'UTVK', N'MATERIAL_NO')
UNION ALL
SELECT NEWID() AS ID,
       N'Weight' AS TypeProperty,
       N'WEIGHT' AS PropertyCode,
       N'МАССА' AS Description,
       NULL AS [Value]
UNION ALL
SELECT NEWID() AS ID,
       N'FactoryNumber' AS TypeProperty,
       N'FactoryNumber' AS PropertyCode,
       N'№ бирки для штрих-кода' AS Description,
       NULL AS [Value];
	  
GO