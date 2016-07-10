SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_MaterialLotPropertySimple', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_MaterialLotPropertySimple];
GO

CREATE VIEW [dbo].[v_MaterialLotPropertySimple]
AS
     SELECT mlp.[ID],
            mlp.[MaterialLotID],
            pt.[Description] PropertyType,
            mlp.[Value]
     FROM [dbo].[MaterialLotProperty] mlp
          INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = mlp.[PropertyType]);
	  
GO


IF OBJECT_ID('dbo.v_MaterialLot', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_MaterialLot];
GO

CREATE VIEW [dbo].[v_MaterialLot]
AS
     SELECT *,
            CASE [Status]
                WHEN '0'
                THEN N'Печать'
                WHEN '1'
                THEN N'Перемаркировка'
                WHEN '2'
                THEN N'Сортировка'
                WHEN '3'
                THEN N'Отбраковка'
                WHEN '4'
                THEN N'Разделение пачки'
            END StatusName,
            CreateTime AS CreatedDateTime
     FROM [dbo].[MaterialLot] mlp;
GO	 
	 
IF OBJECT_ID('dbo.v_OrderProperties', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_OrderProperties];
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
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType AND pt.[Value] IN ('PROD_ORDER','SIZE','LENGTH','TOLERANCE','CLASS','STEEL_CLASS','MELT_NO','PART_NO','MIN_ROD','BUYER_ORDER_NO','BRIGADE_NO','PROD_DATE','UTVK','LEAVE_NO','MATERIAL_NO','BUNT_DIA','PRODUCT','STANDARD','CHEM_ANALYSIS', 'BUNT_NO'))

GO
	 