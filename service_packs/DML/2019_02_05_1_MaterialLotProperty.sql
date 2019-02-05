SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

UPDATE [dbo].[MaterialLot] 
SET [BUNT_NO]=(SELECT prod_date.[Value]
                   FROM [dbo].[MaterialLotProperty] prod_date 
                   WHERE prod_date.[MaterialLotID]=[MaterialLot].[ID]
                     AND prod_date.[PropertyType]=[dbo].[get_PropertyTypeIdByValue](N'BUNT_NO')),
	[PART_NO]=(SELECT prod_date.[Value]
                   FROM [dbo].[MaterialLotProperty] prod_date 
                   WHERE prod_date.[MaterialLotID]=[MaterialLot].[ID]
                     AND prod_date.[PropertyType]=[dbo].[get_PropertyTypeIdByValue](N'PART_NO')),
	[PROD_ORDER]=(SELECT prod_date.[Value]
                   FROM [dbo].[MaterialLotProperty] prod_date 
                   WHERE prod_date.[MaterialLotID]=[MaterialLot].[ID]
                     AND prod_date.[PropertyType]=[dbo].[get_PropertyTypeIdByValue](N'PROD_ORDER'));

GO