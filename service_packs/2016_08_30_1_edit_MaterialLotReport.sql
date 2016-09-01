SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MaterialLotReport', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLotReport;
GO
/*
   View: v_MaterialLotReport
    Возвращает список бирок с информацией для отчетов.
*/
CREATE VIEW [dbo].[v_MaterialLotReport]
AS
     WITH MaterialLotProperties
          AS (SELECT mlp.[ID],
                     mlp.[MaterialLotID],
                     pt.[Value] PropertyType,
                     mlp.[Value]
              FROM [dbo].[MaterialLotProperty] mlp
                   INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = mlp.[PropertyType]))
          SELECT ml.ID,
                 ml.FactoryNumber,                 
                 ml.Quantity,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'CHANGE_NO'
          ) CHANGE_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'BRIGADE_NO'
          ) BRIGADE_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'MELT_NO'
          ) MELT_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PROD_ORDER'
          ) PROD_ORDER,
		(
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PART_NO'
          ) PART_NO,  
		(
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'AUTO_MANU_VALUE'
          ) AUTO_MANU_VALUE, 
		(
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'CREATE_MODE'
          ) CREATE_MODE, 
		(
              SELECT CONVERT(DATETIMEOFFSET(3),[Value],121)
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'MEASURE_TIME'
          ) MEASURE_TIME,
		(
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'MATERIAL_NO'
          ) MATERIAL_NO,
		(
              SELECT CONVERT(DATETIMEOFFSET(3),[Value],104)
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PROD_DATE'
                    AND ISDATE([Value])=1
          ) PROD_DATE,
         (SELECT eq.Equipment
          FROM [dbo].[Equipment] eq
          WHERE eq.ID=[dbo].[get_EquipmentIdByPropertyValue](SUBSTRING(ml.FactoryNumber,7,2),'SCALES_NO')) SideID
          FROM (SELECT ml.[ID],
                                  ml.[FactoryNumber],
                                  ml.[Status],
                                  ml.[Quantity],
						    ml.CreateTime,
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
                           FROM [dbo].[MaterialLot] ml) ml
                     WHERE ml.RowNumber=1;
GO
