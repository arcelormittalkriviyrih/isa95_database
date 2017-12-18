SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF OBJECT_ID ('dbo.v_EquipmentProperty_ScalesNo',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_EquipmentProperty_ScalesNo]
GO

IF OBJECT_ID ('dbo.v_EquipmentProperty_PrinterNo',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_EquipmentProperty_PrinterNo]
GO

/*for changing column drop first dependent views*/
IF COLUMNPROPERTY(OBJECT_ID('EquipmentProperty','U'),'Value','ColumnId') IS NOT NULL    
	ALTER TABLE dbo.EquipmentProperty ALTER COLUMN [Value] nvarchar(500);
GO

/*
   View: v_EquipmentProperty_ScalesNo
    Создана для обеспечения уникальности SCALES_NO.
*/
CREATE VIEW [dbo].[v_EquipmentProperty_ScalesNo]  
AS
SELECT ep.ID, ep.[Value], ep.[Description], ep.EquipmentID, ep.ClassPropertyID
FROM [dbo].[EquipmentProperty] ep
     INNER JOIN [dbo].[EquipmentClassProperty] ecp ON (ecp.ID=ep.ClassPropertyID AND ecp.Value=N'SCALES_NO')
GO


/*
   View: v_EquipmentProperty_PrinterNo
    Создана для обеспечения уникальности PRINTER_NO.
*/
CREATE VIEW [dbo].[v_EquipmentProperty_PrinterNo]  
AS
SELECT ep.ID, ep.[Value], ep.[Description], ep.EquipmentID, ep.ClassPropertyID
FROM [dbo].[EquipmentProperty] ep
     INNER JOIN [dbo].[EquipmentClassProperty] ecp ON (ecp.ID=ep.ClassPropertyID AND ecp.Value=N'PRINTER_NO')
GO

