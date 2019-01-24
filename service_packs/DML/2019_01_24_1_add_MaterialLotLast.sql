SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

Truncate table [dbo].[MaterialLotLast]
GO

INSERT INTO [dbo].[MaterialLotLast] ([FactoryNumber],[MaterialLotID])
SELECT ml.[FactoryNumber],ml.[ID]
FROM (SELECT ml.[ID],
             ml.[FactoryNumber],
             ml.[Status],
             ml.[Quantity],
             ml.CreateTime,
             ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
      FROM [dbo].[MaterialLot] ml
      WHERE ml.[FactoryNumber] IS NOT NULL
        AND NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLotLast] mll WHERE mll.[FactoryNumber]=ml.[FactoryNumber])
     ) ml
WHERE ml.RowNumber=1

GO
