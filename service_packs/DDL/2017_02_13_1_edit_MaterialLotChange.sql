SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_MaterialLotChange', N'V') IS NOT NULL
    DROP VIEW dbo.[v_MaterialLotChange];
GO
/*
   View: v_MaterialLotChange
    Возвращает список бирок для режима изменения заказа.
*/
CREATE VIEW [dbo].[v_MaterialLotChange]
AS
SELECT ml.ID,
       ml.FactoryNumber,
       ml.CreateTime,
       ml.Quantity,
       eq.Equipment SideID,
       prod_order.[Value] PROD_ORDER,
       part_no.[Value] PART_NO,
       bunt_no.[Value] BUNT_NO,
       CAST(0 AS BIT) selected
FROM (SELECT ml.[ID],
             ml.[FactoryNumber],
             ml.[Status],
             ml.[Quantity],
             ml.CreateTime
      FROM (SELECT ml.[ID],
                   ml.[FactoryNumber],
                   ml.[Status],
                   ml.[Quantity],
                   ml.CreateTime,
                   ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
            FROM [dbo].[MaterialLot] ml) ml
            WHERE ml.RowNumber=1) ml
     INNER JOIN [dbo].[Equipment] eq ON (eq.ID=[dbo].[get_EquipmentIdByPropertyValue](SUBSTRING(ml.FactoryNumber,7,2),'SCALES_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] prod_order ON (prod_order.[MaterialLotID]=ml.[ID] AND prod_order.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_ORDER'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] part_no ON (part_no.[MaterialLotID]=ml.[ID] AND part_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PART_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] bunt_no ON (bunt_no.[MaterialLotID]=ml.[ID] AND bunt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BUNT_NO'))
	 WHERE ml.Quantity>0;
GO

