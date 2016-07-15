--------------------------------------------------------------
IF OBJECT_ID('dbo.get_CalculateBindingWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_CalculateBindingWeightByEquipment;
GO

CREATE FUNCTION dbo.get_CalculateBindingWeightByEquipment
(@EquipmentID    INT,
 @OriginalWeight INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @JobOrderID INT, @BINDING_DIA [NVARCHAR](50), @BINDING_QTY [NVARCHAR](50), @BINDING_WEIGHT_COEF FLOAT, @SCALES_TYPE [NVARCHAR](50), @PACK_RULE [NVARCHAR](50), @PACK_WEIGHT [NVARCHAR](50);
         SET @SCALES_TYPE = dbo.get_EquipmentPropertyValue(@EquipmentID, N'SCALES_TYPE');
         IF @SCALES_TYPE = N'BUNT'
             BEGIN
                 SET @PACK_RULE = dbo.get_EquipmentPropertyValue(@EquipmentID, N'PACK_RULE');
                 IF @PACK_RULE = N'CALC'
                     BEGIN
                         SET @JobOrderID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'JOB_ORDER_ID');
                         IF @JobOrderID IS NULL
                             RETURN @OriginalWeight;
                         SET @BINDING_QTY = dbo.get_JobOrderPropertyValue(@JobOrderID, N'BINDING_QTY');
                         SET @BINDING_DIA = dbo.get_JobOrderPropertyValue(@JobOrderID, N'BINDING_DIA');
                         SET @BINDING_WEIGHT_COEF =
                         (
                             SELECT cast(REPLACE(mdpCoef.[Value],',','.') as float)
                             FROM MaterialDefinitionProperty mdpQty
                                  INNER JOIN MaterialClassProperty mcpQty ON mcpQty.ID = mdpQty.ClassPropertyID
                                                                             AND mcpQty.[Value] = N'BINDING_QTY'
                                                                             AND mdpQty.[Value] = @BINDING_QTY
                                  INNER JOIN MaterialDefinitionProperty mdpDia ON mdpDia.MaterialDefinitionID = mdpQty.MaterialDefinitionID
                                  INNER JOIN MaterialClassProperty mcpDia ON mcpDia.ID = mdpDia.ClassPropertyID
                                                                             AND mcpDia.[Value] = N'BINDING_DIA'
                                                                             AND mdpDia.[Value] = @BINDING_DIA
                                  INNER JOIN MaterialDefinitionProperty mdpCoef ON mdpCoef.MaterialDefinitionID = mdpDia.MaterialDefinitionID
                                  INNER JOIN MaterialClassProperty mcpCoef ON mcpCoef.ID = mdpCoef.ClassPropertyID
                                                                              AND mcpCoef.[Value] = N'BINDING_WEIGHT_COEF'
                         );
                         IF @BINDING_WEIGHT_COEF IS NOT NULL
                             RETURN @OriginalWeight * CAST(@BINDING_WEIGHT_COEF AS FLOAT);
                         ELSE
                         RETURN @OriginalWeight;
                     END;
                 ELSE
                 IF @PACK_RULE = N'ENTERED'
                     BEGIN
                         SET @PACK_WEIGHT = dbo.get_EquipmentPropertyValue(@EquipmentID, N'PACK_WEIGHT');
                         IF @PACK_WEIGHT IS NOT NULL
                             RETURN @OriginalWeight - CAST(@PACK_WEIGHT AS FLOAT);
                         ELSE
                         RETURN @OriginalWeight;
                     END;
                 ELSE
                 RETURN @OriginalWeight;;
             END;
         ELSE
         RETURN @OriginalWeight;
         RETURN @OriginalWeight;
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
@BUNT_NO         NVARCHAR(50) = NULL,
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

	 BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   DECLARE @MaterialLotID       INT,
           @PrinterID           NVARCHAR(50),
           @err_message         NVARCHAR(255);

   EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber = @FACTORY_NUMBER,
                                         @Status        = N'1',
                                         @MaterialLotID = @MaterialLotID OUTPUT;

   DECLARE @MILL_ID NVARCHAR(50);
   SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(CAST(@COMM_ORDER AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @COMM_ORDER IS NOT NULL
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
   SELECT N'BUNT_NO',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',@TEMPLATE WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
   EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                       @MaterialLotID = @MaterialLotID,
                                       @Command       = N'Print';

END;
GO

--------------------------------------------------------------
-- Процедура для тестовой печати бирки ins_MaterialLotForTestPrint
IF OBJECT_ID ('dbo.ins_MaterialLotForTestPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotForTestPrint;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotForTestPrint]
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
@BUNT_NO         NVARCHAR(50) = NULL,
@PRODUCT         NVARCHAR(50) = NULL,
@STANDARD        NVARCHAR(50) = NULL,
@CHEM_ANALYSIS   NVARCHAR(50) = NULL,
@TEMPLATE        NVARCHAR(50) = NULL
AS
BEGIN

DECLARE @MaterialLotID INT;

IF @COMM_ORDER IS NOT NULL
	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

EXEC [dbo].[ins_MaterialLot] @FactoryNumber = N'0',
                             @Status        = N'0',
                             @Quantity      = NULL,
                             @MaterialLotID = @MaterialLotID OUTPUT;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(@COMM_ORDER AS NUMERIC(11,0))-5000000000 WHERE @COMM_ORDER IS NOT NULL
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
   SELECT N'BUNT_NO',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
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

   DECLARE @PrinterID NVARCHAR(50);

   DECLARE selPrinters CURSOR FOR SELECT pp.[Value]
                                  FROM [dbo].[PersonProperty] pp
                                       INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'TEST_PRINTER')
                                  WHERE pp.[PersonID]=[dbo].[get_CurrentPerson]();

   OPEN selPrinters

   FETCH NEXT FROM selPrinters INTO @PrinterID
   WHILE @@FETCH_STATUS = 0
   BEGIN

      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';

      FETCH NEXT FROM selPrinters INTO @PrinterID
   END
   CLOSE selPrinters;
   DEALLOCATE selPrinters;

END;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByWorkDefinition
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByWorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByWorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotPropertyByWorkDefinition]
@WorkDefinitionID INT,
@MaterialLotID    INT,
@MEASURE_TIME     NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50),
@MILL_ID          NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL
AS
BEGIN

   DECLARE @LEAVE_NO NVARCHAR(50);
   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   SET @LEAVE_NO =
	   (
		  SELECT sp.[Value]
		  FROM [dbo].[ParameterSpecification] sp
			  INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = sp.[PropertyType])
		  WHERE(sp.WorkDefinitionID = @WorkDefinitionID)
			  AND pt.[Value] = N'COMM_ORDER'
	   );

   INSERT @tblParams
   SELECT pt.[Value],sp.[Value]
   FROM [dbo].[ParameterSpecification] sp
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=sp.[PropertyType])
   WHERE (sp.WorkDefinitionID=@WorkDefinitionID)
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL
   UNION ALL
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL
   UNION ALL
   SELECT N'NEMERA',@NEMERA WHERE @NEMERA IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(CAST(@LEAVE_NO AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @LEAVE_NO IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO
