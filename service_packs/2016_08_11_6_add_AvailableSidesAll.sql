SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_AvailableSidesAll', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableSidesAll];
GO
/*
   View: v_AvailableSides
   Возвращает список доступных сторон без фильтрации по пользователю.
*/
CREATE VIEW [dbo].[v_AvailableSidesAll]
AS
     SELECT DISTINCT
            side.ID,
            workshop.Description+' \ '+mill.Description+' \ '+side.[Description] [Description]
     FROM dbo.Equipment side,
          dbo.Equipment mill,
		dbo.Equipment workshop,
          dbo.EquipmentClass ecp
     WHERE ecp.Code = 'SIDE'           
           AND side.EquipmentClassID = ecp.ID
           AND mill.id = side.Equipment
		 AND workshop.id=mill.Equipment;
GO

