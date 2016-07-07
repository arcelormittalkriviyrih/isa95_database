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
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
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
FROM [dbo].[MaterialLot] ml
     INNER JOIN [dbo].[MaterialLotProperty] mlp ON (mlp.[MaterialLotID]=ml.[ID])
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=mlp.[PropertyType]);
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotWithLinks
IF OBJECT_ID ('dbo.ins_MaterialLotWithLinks',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotWithLinks;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotWithLinks]
@FactoryNumber       NVARCHAR(250),
@Status              NVARCHAR(250),
@Quantity            INT = NULL,
@LinkType            INT = 1,
@LinkFactoryNumber   NVARCHAR(250) = NULL,
@MaterialLotID       INT OUTPUT
AS
BEGIN

  DECLARE @LastMaterialLotID INT,
          @LastQuantity      INT,
          @err_message       NVARCHAR(255);

   SELECT @LastMaterialLotID=ml.[ID],
          @LastQuantity=ml.[Quantity]
   FROM (SELECT ml.[ID],
                ml.[Quantity],
                ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
         FROM [dbo].[MaterialLot] ml
         WHERE ml.[FactoryNumber]=@FactoryNumber) ml
   WHERE ml.RowNumber=1;

   IF @LastMaterialLotID IS NULL
      BEGIN
         SET @err_message = N'By FactoryNumber [' + @FactoryNumber + N'] MaterialLot not found';
         THROW 60010, @err_message, 1;
      END;

   SET @MaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   VALUES (@MaterialLotID,ISNULL(@LinkFactoryNumber,@FactoryNumber),@Status,ISNULL(@Quantity,@LastQuantity));

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@LastMaterialLotID,@MaterialLotID,@LinkType);

END;
GO

--------------------------------------------------------------
-- Процедура для печати перемаркированой бирки ins_MaterialLotByFactoryNumber
IF OBJECT_ID ('dbo.ins_MaterialLotByFactoryNumber',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByFactoryNumber;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotByFactoryNumber]
@EquipmentID     INT,
@FACTORY_NUMBER  NVARCHAR(50),
@COMM_ORDER      NVARCHAR(50) = NULL,
@PROD_ORDER      NVARCHAR(50) = NULL,
@CONTRACT_NO     NVARCHAR(50) = NULL,
@DIRECTION       NVARCHAR(50) = NULL,
@SIZE            NVARCHAR(50) = NULL,
@LENGTH          NVARCHAR(50) = NULL,
@TOLERANCE       NVARCHAR(50) = NULL,
@CLASS           NVARCHAR(50) = NULL,
@STEEL_CLASS     NVARCHAR(50) = NULL,
@MELT_NO         NVARCHAR(50) = NULL,
@PART_NO         NVARCHAR(50) = NULL,
@MIN_ROD         NVARCHAR(50) = NULL,
@BUYER_ORDER_NO  NVARCHAR(50) = NULL,
@BRIGADE_NO      NVARCHAR(50) = NULL,
@PROD_DATE       NVARCHAR(50) = NULL,
@UTVK            NVARCHAR(50) = NULL,
@CHANGE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO     NVARCHAR(50) = NULL,
@BUNT_DIA        NVARCHAR(50) = NULL,
@PRODUCT         NVARCHAR(50) = NULL,
@STANDARD        NVARCHAR(50) = NULL,
@CHEM_ANALYSIS   NVARCHAR(50) = NULL,
@TEMPLATE        NVARCHAR(50) = NULL
AS
BEGIN

   IF @TEMPLATE IS NULL
      THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @COMM_ORDER IS NULL
      THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;

   DECLARE @MaterialLotID       INT,
           @PrinterID           NVARCHAR(50),
           @err_message         NVARCHAR(255);

   EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber = @FACTORY_NUMBER,
                                         @Status        = N'1',
                                         @MaterialLotID = @MaterialLotID OUTPUT;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'PROD_ORDER',@PROD_ORDER WHERE @PROD_ORDER IS NOT NULL
   UNION ALL
   SELECT N'CONTRACT_NO',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
   UNION ALL
   SELECT N'DIRECTION',@DIRECTION WHERE @DIRECTION IS NOT NULL
   UNION ALL
   SELECT N'SIZE',@SIZE WHERE @SIZE IS NOT NULL
   UNION ALL
   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N'TOLERANCE',@TOLERANCE WHERE @TOLERANCE IS NOT NULL
   UNION ALL
   SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
   UNION ALL
   SELECT N'STEEL_CLASS',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
   UNION ALL
   SELECT N'MELT_NO',@MELT_NO WHERE @MELT_NO IS NOT NULL
   UNION ALL
   SELECT N'PART_NO',@PART_NO WHERE @PART_NO IS NOT NULL
   UNION ALL
   SELECT N'MIN_ROD',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
   UNION ALL
   SELECT N'BUYER_ORDER_NO',@BUYER_ORDER_NO WHERE @BUYER_ORDER_NO IS NOT NULL
   UNION ALL
   SELECT N'BRIGADE_NO',@BRIGADE_NO WHERE @BRIGADE_NO IS NOT NULL
   UNION ALL
   SELECT N'PROD_DATE',@PROD_DATE WHERE @PROD_DATE IS NOT NULL
   UNION ALL
   SELECT N'UTVK',@UTVK WHERE @UTVK IS NOT NULL
   UNION ALL
   SELECT N'CHANGE_NO',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_NO',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',@TEMPLATE WHERE @TEMPLATE IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
   EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                       @MaterialLotID = @MaterialLotID,
                                       @Command       = N'Print';

END;
GO
