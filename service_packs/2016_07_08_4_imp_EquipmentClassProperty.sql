SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT NULL FROM [dbo].[EquipmentClassProperty] WHERE [Value]=N'MILL_ID')
   BEGIN
      INSERT INTO [dbo].[EquipmentClassProperty]([Description],[Value],[EquipmentClassID]) (SELECT N'Идентификатор стана',N'MILL_ID',eqc.[ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=N'MILL');

      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z81P',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'ПС 150-1');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z811',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'МС 250-1');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z812',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'МС 250-2');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z813',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'МС 250-3');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z824',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'МС 250-4');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z825',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'МС 250-5');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z83P',[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID') FROM [dbo].[Equipment] WHERE [Description]=N'ПС 6 (ПУ 8)');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z721',q1.[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID')
                                                                                      FROM [dbo].[Equipment] q1 INNER JOIN [dbo].[Equipment] q2 ON q1.[Equipment]=q2.[ID] AND q2.[Description]=N'Блюминг 1 АБК комната мастеров'
                                                                                      WHERE q1.[Description]=N'Стан');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'Z721',q1.[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID')
                                                                                      FROM [dbo].[Equipment] q1 INNER JOIN [dbo].[Equipment] q2 ON q1.[Equipment]=q2.[ID] AND q2.[Description]=N'Блюминг АБК СГП'
                                                                                      WHERE q1.[Description]=N'Стан');
      INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) (SELECT N'P125',q1.[ID],dbo.get_EquipmentClassPropertyByValue(N'MILL_ID')
                                                                                      FROM [dbo].[Equipment] q1 INNER JOIN [dbo].[Equipment] q2 ON q1.[Equipment]=q2.[ID] AND q2.[Description]=N'ЦПМ'
                                                                                      WHERE q1.[Description]=N'Стан');
   END;

IF NOT EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] WHERE [Value]=N'MILL_ID')
   INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MILL_ID',N'Идентификатор стана');

COMMIT;
GO

--------------------------------------------------------------
-- Процедура возвращает ID родителя из таблицы Equipment соответствующего EquipmentClass.Code
IF OBJECT_ID ('dbo.get_ParentEquipmentIDByClass', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_ParentEquipmentIDByClass];
GO

CREATE FUNCTION [dbo].[get_ParentEquipmentIDByClass](@EquipmentID   INT,
                                                     @Code          NVARCHAR(50))
RETURNS INT
AS
BEGIN

DECLARE @ParentEquipmentID INT,
        @ReturnEquipmentID INT,
        @EquipmentClassID  INT;

SELECT @EquipmentClassID=EquipmentClassID,
       @ParentEquipmentID=[Equipment]
FROM [dbo].[Equipment]
WHERE [ID]=@EquipmentID;

WHILE (@EquipmentClassID IS NOT NULL) AND (SELECT [ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=@Code) <> @EquipmentClassID
BEGIN
   SELECT @EquipmentClassID=EquipmentClassID,
          @ReturnEquipmentID=[ID],
          @ParentEquipmentID=[Equipment]
   FROM [dbo].[Equipment]
   WHERE [ID]=@ParentEquipmentID;
END;

RETURN @ReturnEquipmentID;

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
@MILL_ID          NVARCHAR(50) = NULL
AS
BEGIN

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

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
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotByEquipment
IF OBJECT_ID ('dbo.ins_MaterialLotByEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------
-- Используется для тестовой печати и для ручной печати с вводом кол-ва
CREATE PROCEDURE [dbo].[ins_MaterialLotByEquipment]
@EquipmentID   INT,
@Quantity      INT = NULL
AS
BEGIN

DECLARE @MaterialLotID    INT,
        @WorkDefinitionID INT,
        @AUTO_MANU_VALUE [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50),
        @Status          [NVARCHAR](250);

SET @Status=N'0';
SET @AUTO_MANU_VALUE=N'0';

IF @Quantity IS NOT NULL
   BEGIN
      SET @Status=[dbo].[get_MaterialLotStatusByWorkType]([dbo].[get_CurrentWorkType](@EquipmentID));
      SET @AUTO_MANU_VALUE=N'1';
   END;

SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = @Status,
                             @Quantity      = @Quantity,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
IF @WorkDefinitionID IS NOT NULL
   BEGIN
      DECLARE @MEASURE_TIME NVARCHAR(50),
              @MILL_ID      NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE,
                                                           @MILL_ID          = @MILL_ID;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;
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
-- Процедура ins_JobOrderPrintLabelByControllerNo
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabelByControllerNo',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabelByControllerNo;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabelByControllerNo]
@CONTROLLER_NO   NVARCHAR(50),
@TIMESTAMP       DATETIME,
@WEIGHT_FIX      INT,
@AUTO_MANU       BIT
AS
BEGIN
   BEGIN TRY

      DECLARE @EquipmentID      INT,
              @FactoryNumber    [NVARCHAR](12),
              @PrinterID        [NVARCHAR](50),
              @JobOrderID       INT,
              @WorkType         [NVARCHAR](50),
              @WorkDefinitionID INT,
              @MaterialLotID    INT,
              @Status           NVARCHAR(250),
              @err_message      NVARCHAR(255);

      SET @EquipmentID=dbo.get_EquipmentIDByControllerNo(@CONTROLLER_NO);
      IF @EquipmentID IS NULL
         BEGIN
            SET @err_message = N'By CONTROLLER_NO=[' + @CONTROLLER_NO + N'] EquipmentID not found';
            THROW 60010, @err_message, 1;
         END;
/*
      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;
*/
      SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
      IF @JobOrderID IS NULL
         BEGIN
            SET @err_message = N'JobOrder is missing for EquipmentID=[' + CAST(@EquipmentID AS NVARCHAR) + N']';
            THROW 60010, @err_message, 1;
         END;

      SELECT @WorkType=wr.[WorkType]
      FROM [dbo].[JobOrder] jo INNER JOIN [dbo].[WorkRequest] wr ON (wr.[ID]=jo.[WorkRequest])
      WHERE jo.[ID]=@JobOrderID;

      SET @Status=[dbo].[get_MaterialLotStatusByWorkType](@WorkType);
      IF @WorkType IN (N'Standard')
         BEGIN
            SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
            EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                                         @Status        = @Status,
                                         @Quantity      = @WEIGHT_FIX,
                                         @MaterialLotID = @MaterialLotID OUTPUT;
         END;
      ELSE IF @WorkType IN (N'Sort',N'Reject')
         BEGIN
            SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');
            EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber       = @FactoryNumber,
                                                  @Status              = @Status,
                                                  @LinkedMaterialLotID = @MaterialLotID OUTPUT;
         END;
      ELSE IF @WorkType IN (N'Separate')
         BEGIN
            DECLARE @LinkFactoryNumber   [NVARCHAR](12);
            SET @LinkFactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
            SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');
            EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber       = @FactoryNumber,
                                                  @Status              = @Status,
                                                  @Quantity            = @WEIGHT_FIX,
                                                  @LinkFactoryNumber   = @LinkFactoryNumber,
                                                  @LinkedMaterialLotID = @MaterialLotID OUTPUT;
         END;

      DECLARE @MEASURE_TIME [NVARCHAR](50),
              @MILL_ID      NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,@TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');
      SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU,
                                                           @MILL_ID          = @MILL_ID;
/*
      EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                     @JobOrderID      = @JobOrderID,
                                                     @MEASURE_TIME    = @MEASURE_TIME,
                                                     @AUTO_MANU_VALUE = @AUTO_MANU;
*/
      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END TRY
   BEGIN CATCH
     EXEC [dbo].[ins_ErrorLog];
   END CATCH
END
GO
