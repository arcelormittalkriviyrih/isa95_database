SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MaterialLotProperty', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLotProperty;
GO
/*
   View: v_MaterialLotProperty
    Возвращает список свойств бирки.
	Используется в спец режимах.
*/
CREATE VIEW [dbo].[v_MaterialLotProperty]
AS
SELECT mlp.[ID],
       ml.[ID] MaterialLotID,
       ml.[FactoryNumber],
       ml.[Status],
       ml.[Quantity],
       mlp.[PropertyType] PropertyID,
       pt.[Value] Property,
       mlp.[Value]
FROM [dbo].[MaterialLot] ml
	 INNER JOIN [dbo].[MaterialLotLast] mll ON (mll.[MaterialLotID]=ml.[ID])   
     INNER JOIN [dbo].[MaterialLotProperty] mlp ON (mlp.[MaterialLotID]=ml.[ID])
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=mlp.[PropertyType])
WHERE ml.[Quantity]	> 0;
GO
