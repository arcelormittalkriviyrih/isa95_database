SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

UPDATE [dbo].[MaterialLot] 
SET [SideID]=(SELECT eq.[Equipment]
                    FROM [dbo].[EquipmentProperty] eqp
                         INNER JOIN [dbo].[Equipment] eq ON (eq.ID=eqp.[EquipmentID])
                    WHERE eqp.[ClassPropertyID]=[dbo].[get_EquipmentClassPropertyByValue](N'SCALES_NO')
                      AND eqp.[Value]=[FactoryNumberScales]),
     [ProdDate]=(SELECT prod_date.[ValueDate]
                   FROM [dbo].[MaterialLotProperty] prod_date 
                   WHERE prod_date.[MaterialLotID]=[MaterialLot].[ID]
                     AND prod_date.[PropertyType]=[dbo].[get_PropertyTypeIdByValue](N'PROD_DATE'))

GO