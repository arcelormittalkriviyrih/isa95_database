IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'MaterialLot'
                AND column_name = 'CreateTime')
   ALTER TABLE [dbo].[MaterialLot] ADD [CreateTime] [datetimeoffset] NULL DEFAULT(CURRENT_TIMESTAMP)
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_MaterialLot' AND object_id = OBJECT_ID('[dbo].[MaterialLot]'))
   DROP INDEX [i1_MaterialLot] ON [dbo].[MaterialLot]
GO

CREATE INDEX [i1_MaterialLot] ON [dbo].[MaterialLot] ([FactoryNumber]) INCLUDE ([CreateTime])
GO
-------------
IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u1_MaterialLotProperty' AND object_id = OBJECT_ID('[dbo].[MaterialLotProperty]'))
   DROP INDEX [u1_MaterialLotProperty] ON [dbo].[MaterialLotProperty]
GO

CREATE UNIQUE INDEX [u1_MaterialLotProperty] ON [dbo].[MaterialLotProperty] ([MaterialLotID],[PropertyType]) INCLUDE ([Value])
GO

-------------
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MaterialLotProperty', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLotProperty;
GO

CREATE VIEW [dbo].[v_MaterialLotProperty]
AS
WITH MaterialLot AS (SELECT ml.[ID],
                            ml.[FactoryNumber],
                            ml.[Status],
                            ml.[Quantity]
                     FROM (SELECT ml.[ID],
                                  ml.[FactoryNumber],
                                  ml.[Status],
                                  ml.[Quantity],
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC) RowNumber
                           FROM [dbo].[MaterialLot] ml) ml
                     WHERE ml.RowNumber=1) 
SELECT mlp.[ID],
       ml.[ID] MaterialLotID,
       ml.[FactoryNumber],
       ml.[Status],
       ml.[Quantity],
       mlp.[PropertyType] PropertyID,
       pt.[Value] Property,
       mlp.[Value]
FROM MaterialLot ml
     INNER JOIN [dbo].[MaterialLotProperty] mlp ON (mlp.[MaterialLotID]=ml.[ID])
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=mlp.[PropertyType]);
GO
