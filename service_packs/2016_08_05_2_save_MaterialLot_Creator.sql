--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByWorkDefinition
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByWorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByWorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotPropertyByWorkDefinition
	Добавляет свойства бирки из WorkDefinition.

	Parameters:

		MaterialLotID    - MaterialLot ID,
		WorkRequestID    - WorkRequest ID,
		MEASURE_TIME	 - Дата и время,
        AUTO_MANU_VALUE  - Признак AUTO_MANU,
		MILL_ID			 - ID стана
		NEMERA			 - Признак "Немера"
        IDENT			 - Идентификатор взвешивания

	
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotPropertyByWorkDefinition]
@WorkDefinitionID INT,
@MaterialLotID    INT,
@MEASURE_TIME     NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50),
@MILL_ID          NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL,
@IDENT			  NVARCHAR(50) = NULL,
@CREATE_MODE	  NVARCHAR(50) = NULL
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
   SELECT N'LEAVE_NO',CAST(CAST(@LEAVE_NO AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @LEAVE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_LOT_IDENT',@IDENT WHERE @IDENT IS NOT NULL
   UNION ALL
   SELECT N'CREATOR',SYSTEM_USER
   UNION ALL
   SELECT N'CREATE_MODE',@CREATE_MODE WHERE @CREATE_MODE IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура для тестовой печати бирки ins_MaterialLotForTestPrint
IF OBJECT_ID ('dbo.ins_MaterialLotForTestPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotForTestPrint;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotForTestPrint
	Используется для тестовой печати.

	Parameters:

		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
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

DECLARE @PrinterID NVARCHAR(50);

SET @PrinterID = (SELECT pp.[Value]
                                FROM [dbo].[PersonProperty] pp
                                    INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'TEST_PRINTER')
                                WHERE pp.[PersonID]=[dbo].[get_CurrentPerson]())
IF @PrinterID IS NULL
THROW 60001, N'Тестовый принтер не указан в настройках!', 1;

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
   SELECT N'CREATOR',SYSTEM_USER
   UNION ALL
   SELECT N'CREATE_MODE',N'Тестовая печать';

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   
    EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                        @MaterialLotID = @MaterialLotID,
                                        @Command       = N'Print';  

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

/*
	Procedure: ins_MaterialLotByEquipment
	Используется для тестовой печати и для ручной печати с вводом кол-ва.

	Parameters:

		EquipmentID     - ID весов,
		Quantity        - Значение веса.
*/
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
        @Status          [NVARCHAR](250),
	    @JobOrderID      INT,
        @WorkType	     [NVARCHAR](50),
		@CREATE_MODE	 [NVARCHAR](50);

SET @Status=N'0';
SET @AUTO_MANU_VALUE=N'0';
SET @WorkType = [dbo].[get_CurrentWorkType](@EquipmentID);
SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
SET @CREATE_MODE = N'Тестовая печать';

IF @Quantity IS NOT NULL
   BEGIN
      SET @Status=[dbo].[get_MaterialLotStatusByWorkType](@WorkType);
      SET @AUTO_MANU_VALUE=N'1';
      SET @Quantity=dbo.get_RoundedWeightByEquipment(@Quantity,@EquipmentID);
	  SET @CREATE_MODE = N'Печать с ручным вводом веса';
   END;

IF @WorkType IN (N'Sort',N'Reject')	     
    SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');	   
ELSE 
    SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);

EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = @Status,
                             @Quantity      = @Quantity,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

IF @WorkDefinitionID IS NOT NULL
   BEGIN
      DECLARE @MEASURE_TIME NVARCHAR(50),
              @MILL_ID      NVARCHAR(50),
              @NEMERA       NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');      
      SET @NEMERA=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'NEMERA');
      
	 EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE,
                                                           @MILL_ID          = @MILL_ID,
                                                           @NEMERA           = @NEMERA,
														   @CREATE_MODE		 = @CREATE_MODE;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;

IF @WorkType = N'Separate'
    EXEC [dbo].[set_DecreasePacksLeft] @EquipmentID=@EquipmentID;
IF @WorkType IN (N'Sort',N'Reject')
    EXEC dbo.set_StandardMode @EquipmentID=@EquipmentID; 

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByScalesNo


IF OBJECT_ID('dbo.ins_JobOrderPrintLabelByScalesNo', N'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo;
    END;
GO

SET QUOTED_IDENTIFIER ON;
GO
/*
	Procedure: ins_JobOrderToPrint
	Процедура создания бирки и Job на печать бирки.

	Parameters:

		SCALES_NO  - Идентификатор весов,
		TIMESTAMP  - Дата и время,
        WEIGHT_FIX - Вес,
        AUTO_MANU  - Признак AUTO_MANU,
        IDENT      - Идентификатор взвешивания

	
*/
CREATE PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo @SCALES_NO  NVARCHAR(50),
                                                      @TIMESTAMP  DATETIME,
                                                      @WEIGHT_FIX INT,
                                                      @AUTO_MANU  BIT,
                                                      @IDENT      NVARCHAR(50)
AS
     BEGIN
         BEGIN TRY
             DECLARE @EquipmentID INT, @FactoryNumber NVARCHAR(12), @PrinterID NVARCHAR(50), @JobOrderID INT, @WorkType NVARCHAR(50), @WorkDefinitionID INT, @MaterialLotID INT, @Status NVARCHAR(250), @err_message NVARCHAR(255), @Weight_Rounded INT;
             IF NOT EXISTS
             (
                 SELECT NULL
                 FROM MaterialLotProperty AS mlp,
                      PropertyTypes AS pt
                 WHERE pt.ID = mlp.PropertyType
                       AND pt.[Value] = N'MATERIAL_LOT_IDENT'
                       AND mlp.[Value] = @IDENT
             )
                 BEGIN
                     SET @EquipmentID = dbo.get_EquipmentIDByScalesNo(@SCALES_NO);
                     IF @EquipmentID IS NULL
                         BEGIN
                             SET @err_message = N'By SCALES_NO=['+@SCALES_NO+N'] EquipmentID not found';
                             THROW 60010, @err_message, 1;
                         END;

/*
      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;
*/

                     SET @Weight_Rounded = dbo.get_RoundedWeightByEquipment(@WEIGHT_FIX, @EquipmentID);
                     SET @JobOrderID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'JOB_ORDER_ID');
                     IF @JobOrderID IS NULL
                         BEGIN
                             SET @err_message = N'JobOrder is missing for EquipmentID=['+CAST(@EquipmentID AS NVARCHAR)+N']';
                             THROW 60010, @err_message, 1;
                         END;
                     SELECT @WorkType = wr.WorkType
                     FROM dbo.JobOrder AS jo
                          INNER JOIN dbo.WorkRequest AS wr ON wr.ID = jo.WorkRequest
                     WHERE jo.ID = @JobOrderID;
                     SET @Status = dbo.get_MaterialLotStatusByWorkType(@WorkType);
                     IF @WorkType IN(N'Standard')
                         BEGIN
                             SET @FactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
                             EXEC dbo.ins_MaterialLot
                                  @FactoryNumber = @FactoryNumber,
                                  @Status = @Status,
                                  @Quantity = @Weight_Rounded,
                                  @MaterialLotID = @MaterialLotID OUTPUT;
                         END;
                     ELSE
                         BEGIN
                             IF @WorkType IN(N'Sort', N'Reject')
                                 BEGIN
                                     SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
                                     EXEC dbo.ins_MaterialLotWithLinks
                                          @FactoryNumber = @FactoryNumber,
                                          @Status = @Status,
                                          @Quantity = @Weight_Rounded,
                                          @MaterialLotID = @MaterialLotID OUTPUT;
                                     EXEC dbo.set_StandardMode
                                          @EquipmentID = @EquipmentID;
                                 END;
                             ELSE
                                 BEGIN
                                     IF @WorkType IN(N'Separate')
                                         BEGIN
                                             DECLARE @LinkFactoryNumber NVARCHAR(12);
                                             SET @LinkFactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
                                             SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
                                             EXEC dbo.ins_MaterialLotWithLinks
                                                  @FactoryNumber = @FactoryNumber,
                                                  @Status = @Status,
                                                  @Quantity = @Weight_Rounded,
                                                  @LinkFactoryNumber = @LinkFactoryNumber,
                                                  @MaterialLotID = @MaterialLotID OUTPUT;
                                             EXEC dbo.set_DecreasePacksLeft
                                                  @EquipmentID = @EquipmentID;
                                         END;
                                 END;
                         END;
                     DECLARE @MEASURE_TIME NVARCHAR(50), @MILL_ID NVARCHAR(50), @NEMERA NVARCHAR(50);
                     SET @MEASURE_TIME = CONVERT(NVARCHAR, @TIMESTAMP, 121);
                     SET @MILL_ID = dbo.get_EquipmentPropertyValue(dbo.get_ParentEquipmentIDByClass(@EquipmentID, N'MILL'), N'MILL_ID');
                     SET @WorkDefinitionID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'WORK_DEFINITION_ID');
                     SET @NEMERA = dbo.get_JobOrderPropertyValue(@JobOrderID, N'NEMERA');
                     EXEC dbo.ins_MaterialLotPropertyByWorkDefinition
                          @WorkDefinitionID = @WorkDefinitionID,
                          @MaterialLotID = @MaterialLotID,
                          @MEASURE_TIME = @MEASURE_TIME,
                          @AUTO_MANU_VALUE = @AUTO_MANU,
                          @MILL_ID = @MILL_ID,
                          @NEMERA = @NEMERA,
						  @IDENT = @IDENT,
						  @CREATE_MODE = N'Авто печать';

/*
      EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                     @JobOrderID      = @JobOrderID,
                                                     @MEASURE_TIME    = @MEASURE_TIME,
                                                     @AUTO_MANU_VALUE = @AUTO_MANU;
*/

                     SET @PrinterID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'USED_PRINTER');
                     EXEC dbo.ins_JobOrderPrintLabel
                          @PrinterID = @PrinterID,
                          @MaterialLotID = @MaterialLotID,
                          @Command = N'Print';
                 END;
         END TRY
         BEGIN CATCH
             EXEC dbo.ins_ErrorLog;
         END CATCH;
     END;
GO