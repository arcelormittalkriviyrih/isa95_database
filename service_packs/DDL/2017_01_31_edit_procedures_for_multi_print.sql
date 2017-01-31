IF OBJECT_ID ('dbo.v_OrderProperties', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderProperties;
GO
/*
   View: v_OrderProperties
    Возвращает список свойств заказа.
	Используется на странице заказов.
*/
CREATE VIEW [dbo].[v_OrderProperties]
AS
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       sr.OperationsRequest,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType AND pt.[Value] not IN ('TEMPLATE','COMM_ORDER','DIRECTION','CONTRACT_NO'))

GO

--------------------------------------------------------------
-- Процедура ins_CreateOrder
IF OBJECT_ID ('dbo.ins_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_Order;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_Order
	Процедура добаления заказа.

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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.

*/
CREATE PROCEDURE [dbo].[ins_Order]
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250) = NULL,
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN
   DECLARE @OperationsRequestID     INT,
           @OpSegmentRequirementID  INT,
           @err_message             NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
   ELSE IF EXISTS (SELECT NULL FROM [dbo].[v_SegmentParameter_Order] WHERE [Value]=@COMM_ORDER)
      BEGIN
         SET @err_message = N'Заказ [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] уже существует';
         THROW 60010, @err_message, 1;
      END;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;
	
	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   SET @OperationsRequestID=NEXT VALUE FOR [dbo].[gen_OperationsRequest];
   INSERT INTO [dbo].[OperationsRequest] ([ID]) VALUES (@OperationsRequestID);

   SET @OpSegmentRequirementID=NEXT VALUE FOR [dbo].[gen_OpSegmentRequirement];
   INSERT INTO [dbo].[OpSegmentRequirement] ([ID],[OperationsRequest]) VALUES (@OpSegmentRequirementID,@OperationsRequestID);

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
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'LABEL_PRINT_QTY',CAST(@LABEL_PRINT_QTY AS NVARCHAR(50)) WHERE @LABEL_PRINT_QTY IS NOT NULL;

   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
   SELECT t.value,@OpSegmentRequirementID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrder
IF OBJECT_ID ('dbo.ins_JobOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrder;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.ins_JobOrder
	Процедура вставки JobOrder.

	Parameters:

		WorkType		- Режим,
		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		ProfileID       - ID профиля,
		COMM_ORDER      - Номер коммерческого заказа,
		LENGTH          - Длина,
		BAR_WEIGHT      - Вес прутка,
		BAR_QUANTITY    - Количество прутков,
		MAX_WEIGHT      - Максимальный вес,
		MIN_WEIGHT      - Минимальный вес,
		SAMPLE_WEIGHT   - Вес образца,
		SAMPLE_LENGTH   - Длина образца,
		DEVIATION       - Отклонение,
		SANDWICH_MODE   - Признак "Бутерброд",
		AUTO_MANU_VALUE - Признак "Автоматический режим",
		NEMERA          - Признак "Немера",
		FACTORY_NUMBER  - Номер бирки,
		PACKS_LEFT      - Количество оставшихся пачек для режима "Разделение пачки",
		BINDING_DIA     - Диаметр увязки,
		BINDING_QTY     - Количество увязок,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки,
		JobOrderID      - Job Order ID OUTPUT.

*/

CREATE PROCEDURE [dbo].[ins_JobOrder]
@WorkType         NVARCHAR(50),
@WorkRequestID    INT,
@EquipmentID      INT,
@ProfileID        INT          = NULL,
@COMM_ORDER       NVARCHAR(250) = NULL,
@LENGTH           NVARCHAR(250) = NULL,
@BAR_WEIGHT       NVARCHAR(250) = NULL,
@BAR_QUANTITY     NVARCHAR(250) = NULL,
@MAX_WEIGHT       NVARCHAR(250) = NULL,
@MIN_WEIGHT       NVARCHAR(250) = NULL,
@SAMPLE_WEIGHT    NVARCHAR(250) = NULL,
@SAMPLE_LENGTH    NVARCHAR(250) = NULL,
@DEVIATION        NVARCHAR(250) = NULL,
@SANDWICH_MODE    NVARCHAR(250) = NULL,
@AUTO_MANU_VALUE  NVARCHAR(250) = NULL,
@NEMERA           NVARCHAR(250) = NULL,
@FACTORY_NUMBER   NVARCHAR(50) = NULL,
@PACKS_LEFT       NVARCHAR(250) = NULL,
@BINDING_DIA      NVARCHAR(250) = NULL,
@BINDING_QTY      NVARCHAR(250) = NULL,
@LABEL_PRINT_QTY  INT           = NULL,
@JobOrderID       INT OUTPUT
AS
BEGIN

   UPDATE [dbo].[JobOrder]
   SET [WorkType]=[WorkType]+N'_archive'
   WHERE [WorkRequest]=@WorkRequestID
     AND [WorkType]=@WorkType;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest])
   VALUES (@JobOrderID,@WorkType,CURRENT_TIMESTAMP,@WorkRequestID);

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@JobOrderID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N'JOB_ORDER_ID',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

   IF @WorkType IN (N'Standard')
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N'STANDARD_JOB_ORDER_ID',
                                         @EquipmentPropertyValue = @EquipmentPropertyValue;

   if @ProfileID is not null	
	   INSERT INTO [dbo].[OpMaterialRequirement] ([MaterialClassID],[MaterialDefinitionID],[JobOrderID])
	   SELECT md.[MaterialClassID],md.[ID],@JobOrderID
	   FROM [dbo].[MaterialDefinition] md
	   WHERE md.[ID]=@ProfileID;

   INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq 
   WHERE eq.[ID]=@EquipmentID;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N'BAR_WEIGHT',@BAR_WEIGHT WHERE @BAR_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'BAR_QUANTITY',@BAR_QUANTITY WHERE @BAR_QUANTITY IS NOT NULL
   UNION ALL
   SELECT N'MAX_WEIGHT',@MAX_WEIGHT WHERE @MAX_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'MIN_WEIGHT',@MIN_WEIGHT WHERE @MIN_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'SAMPLE_WEIGHT',@SAMPLE_WEIGHT WHERE @SAMPLE_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'SAMPLE_LENGTH',@SAMPLE_LENGTH WHERE @SAMPLE_LENGTH IS NOT NULL
   UNION ALL
   SELECT N'DEVIATION',@DEVIATION WHERE @DEVIATION IS NOT NULL
   UNION ALL
   SELECT N'SANDWICH_MODE',@SANDWICH_MODE WHERE @SANDWICH_MODE IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL
   UNION ALL
   SELECT N'NEMERA',@NEMERA WHERE @NEMERA IS NOT NULL
   UNION ALL
   SELECT N'FACTORY_NUMBER',@FACTORY_NUMBER WHERE @FACTORY_NUMBER IS NOT NULL
   UNION ALL
   SELECT N'PACKS_LEFT',@PACKS_LEFT WHERE @PACKS_LEFT IS NOT NULL
   UNION ALL
   SELECT N'BINDING_DIA',@BINDING_DIA WHERE @BINDING_DIA IS NOT NULL
   UNION ALL
   SELECT N'BINDING_QTY',@BINDING_QTY WHERE @BINDING_QTY IS NOT NULL
   UNION ALL
   SELECT N'LABEL_PRINT_QTY',CAST(@LABEL_PRINT_QTY AS NVARCHAR(50)) WHERE @LABEL_PRINT_QTY IS NOT NULL;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT t.value,@JobOrderID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderToPrint
IF OBJECT_ID ('dbo.ins_JobOrderToPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderToPrint;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderToPrint
	Процедура создания Job на печать или отправку бирки.

	Parameters:

		EquipmentID   - ID весов,
		MaterialLotID - MaterialLot ID,
		Command       - Email или Print,
		CommandRule   - Список адресов,
		WorkRequestID - WorkRequestID

	See Also:

		<ins_JobOrderPrintLabel>
*/
CREATE PROCEDURE [dbo].[ins_JobOrderToPrint]
@EquipmentID     INT,
@MaterialLotID   INT,
@Command         NVARCHAR(50),
@CommandRule     NVARCHAR(50) = NULL,
@WorkRequestID   INT = NULL

AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255),
		   @LABEL_PRINT_QTY NVARCHAR(250);

   IF NOT EXISTS (SELECT NULL 
                  FROM [dbo].[Equipment] eq INNER JOIN [dbo].[EquipmentClass] eqc ON (eqc.[ID] = eq.[EquipmentClassID] AND eqc.[Code]=N'PRINTER')
                  WHERE eq.[ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment ID=[' + CAST(@EquipmentID AS NVARCHAR) + N'] is not a PRINTER';
         THROW 60010, @err_message, 1;
      END;

   SELECT @LABEL_PRINT_QTY=[Value] FROM [dbo].[MaterialLotProperty] 
   where PropertyType=[dbo].[get_PropertyTypeIdByValue](N'LABEL_PRINT_QTY') 
   and MaterialLotID=@MaterialLotID;

   IF @LABEL_PRINT_QTY = N'2'
	BEGIN
		SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
	   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[Command],[CommandRule],[WorkRequest])
	   VALUES (@JobOrderID,N'Print',N'ToPrint',CURRENT_TIMESTAMP,@Command,@CommandRule,@WorkRequestID);

	   INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
	   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
	   FROM [dbo].[Equipment] eq
	   WHERE [ID]=@EquipmentID;

	   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
	   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
	   FROM [dbo].[PropertyTypes] pt
	   WHERE pt.[Value]=N'MaterialLotID';
	END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[Command],[CommandRule],[WorkRequest])
   VALUES (@JobOrderID,N'Print',N'ToPrint',CURRENT_TIMESTAMP,@Command,@CommandRule,@WorkRequestID);

   INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq
   WHERE [ID]=@EquipmentID;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

   IF @Command = N'Print'
    EXEC dbo.[ins_JobOrderSAPExport]
         @MaterialLotID = @MaterialLotID,
         @WorkRequestID = @WorkRequestID;

END;
GO



--------------------------------------------------------------
-- Процедура для печати перемаркированой бирки ins_MaterialLotByFactoryNumber
IF OBJECT_ID ('dbo.ins_MaterialLotByFactoryNumber',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByFactoryNumber;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotByFactoryNumber
	Используется для режима перемаркировки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки,
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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotByFactoryNumber]
@EquipmentID     INT,
@FACTORY_NUMBER  NVARCHAR(50),
@COMM_ORDER      NVARCHAR(250) = NULL,
@PROD_ORDER      NVARCHAR(250) = NULL,
@CONTRACT_NO     NVARCHAR(250) = NULL,
@DIRECTION       NVARCHAR(250) = NULL,
@SIZE            NVARCHAR(250) = NULL,
@LENGTH          NVARCHAR(250) = NULL,
@TOLERANCE       NVARCHAR(250) = NULL,
@CLASS           NVARCHAR(250) = NULL,
@STEEL_CLASS     NVARCHAR(250) = NULL,
@MELT_NO         NVARCHAR(250) = NULL,
@PART_NO         NVARCHAR(250) = NULL,
@MIN_ROD         NVARCHAR(250) = NULL,
@BUYER_ORDER_NO  NVARCHAR(250) = NULL,
@BRIGADE_NO      NVARCHAR(250) = NULL,
@PROD_DATE       NVARCHAR(250) = NULL,
@UTVK            NVARCHAR(250) = NULL,
@CHANGE_NO       NVARCHAR(250) = NULL,
@MATERIAL_NO     NVARCHAR(250) = NULL,
@BUNT_DIA        NVARCHAR(250) = NULL,
@BUNT_NO         NVARCHAR(250) = NULL,
@PRODUCT         NVARCHAR(250) = NULL,
@STANDARD        NVARCHAR(250) = NULL,
@CHEM_ANALYSIS   NVARCHAR(250) = NULL,
@TEMPLATE        NVARCHAR(50)  = NULL,
@LABEL_PRINT_QTY INT           = NULL
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

   DECLARE @MILL_ID NVARCHAR(50),
           @MEASURE_TIME NVARCHAR(50);
   SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');
   SET @MEASURE_TIME=FORMAT(CURRENT_TIMESTAMP, 'dd.MM.yyyy HH:mm:ss');

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

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
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL
   UNION ALL
   SELECT N'LABEL_PRINT_QTY',CAST(@LABEL_PRINT_QTY AS NVARCHAR(50)) WHERE @LABEL_PRINT_QTY IS NOT NULL;

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
-- Процедура ins_WorkDefinition
IF OBJECT_ID ('dbo.ins_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkDefinition
	Процедура добаления WorkDefinition.

	Parameters:

		WorkType	   - Режим,
		EquipmentID    - ID весов,
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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[ins_WorkDefinition]
@WorkType       NVARCHAR(50),
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN
   DECLARE @WorkDefinitionID           INT,
           @OperationsSegmentID        INT,
           @OpEquipmentSpecificationID INT,
           @err_message                NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
   ELSE IF @WorkType IN (N'Standart') AND EXISTS (SELECT NULL FROM [dbo].[v_ParameterSpecification_Order] WHERE [Value]=@COMM_ORDER AND [EquipmentID]=@EquipmentID)
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] already exists';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @PROD_ORDER IS NULL
    THROW 60001, N'Параметр "Производственный заказ" обязательный', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CLASS IS NULL
    THROW 60001, N'CLASS param required', 1;
   ELSE IF @STEEL_CLASS IS NULL
    THROW 60001, N'STEEL_CLASS param required', 1;
   ELSE IF @MELT_NO IS NULL
    THROW 60001, N'MELT_NO param required', 1;
   ELSE IF @PART_NO IS NULL
    THROW 60001, N'PART_NO param required', 1;
   ELSE IF @BRIGADE_NO IS NULL
    THROW 60001, N'BRIGADE_NO param required', 1;
   ELSE IF @PROD_DATE IS NULL
    THROW 60001, N'PROD_DATE param required', 1;
   ELSE IF @UTVK IS NULL
    THROW 60001, N'UTVK param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   SET @WorkDefinitionID=NEXT VALUE FOR [dbo].[gen_WorkDefinition];
   INSERT INTO [dbo].[WorkDefinition] ([ID],[WorkType],[PublishedDate]) VALUES (@WorkDefinitionID,@WorkType,CURRENT_TIMESTAMP);

   SET @OperationsSegmentID=NEXT VALUE FOR [dbo].[gen_OperationsSegment];
   INSERT INTO [dbo].[OperationsSegment] ([ID],[OperationsType]) VALUES (@OperationsSegmentID,N'Standard');

   SET @OpEquipmentSpecificationID=NEXT VALUE FOR [dbo].[gen_OpEquipmentSpecification];
   INSERT INTO [dbo].[OpEquipmentSpecification]([ID],[EquipmentClassID],[EquipmentID],[OperationSegmentID],[WorkDefinition])
   SELECT @OpEquipmentSpecificationID,eq.[EquipmentClassID],eq.[ID],@OperationsSegmentID,@WorkDefinitionID
   FROM [dbo].[Equipment] eq
   WHERE eq.[ID]=@EquipmentID;

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@WorkDefinitionID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N'WORK_DEFINITION_ID',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

   IF @WorkType IN (N'Standard')
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N'STANDARD_WORK_DEFINITION_ID',
                                         @EquipmentPropertyValue = @EquipmentPropertyValue;

/*
   DECLARE @JobOrderID INT;
   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   IF @JobOrderID IS NOT NULL
      BEGIN
         INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
         SELECT CAST(@WorkDefinitionID AS NVARCHAR),@JobOrderID,pt.ID
         FROM [dbo].[PropertyTypes] pt 
         WHERE (pt.value=N'WORK_DEFINITION_ID');
      END;
*/
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
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'LABEL_PRINT_QTY',CAST(@LABEL_PRINT_QTY AS NVARCHAR(50)) WHERE @LABEL_PRINT_QTY IS NOT NULL;

   INSERT INTO [dbo].[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
   SELECT t.value,@WorkDefinitionID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkDefinitionStandard
IF OBJECT_ID ('dbo.ins_WorkDefinitionStandard',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinitionStandard;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkDefinitionStandard
	Процедура добаления стандартного WorkDefinition.

	Parameters:

		EquipmentID    - ID весов,
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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.

	See Also:

		<ins_WorkDefinition>

*/
CREATE PROCEDURE [dbo].[ins_WorkDefinitionStandard]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN

EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Standard',
                                @EquipmentID    = @EquipmentID,
                                @COMM_ORDER     = @COMM_ORDER,
                                @PROD_ORDER     = @PROD_ORDER,
                                @CONTRACT_NO    = @CONTRACT_NO,
                                @DIRECTION      = @DIRECTION,
                                @SIZE           = @SIZE,
                                @LENGTH         = @LENGTH,
                                @TOLERANCE      = @TOLERANCE,
                                @CLASS          = @CLASS,
                                @STEEL_CLASS    = @STEEL_CLASS,
                                @MELT_NO        = @MELT_NO,
                                @PART_NO        = @PART_NO,
                                @MIN_ROD        = @MIN_ROD,
                                @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                @BRIGADE_NO     = @BRIGADE_NO,
                                @PROD_DATE      = @PROD_DATE,
                                @UTVK           = @UTVK,
                                @CHANGE_NO      = @CHANGE_NO,
                                @MATERIAL_NO    = @MATERIAL_NO,
                                @BUNT_DIA       = @BUNT_DIA,
                                @BUNT_NO        = @BUNT_NO,
                                @PRODUCT        = @PRODUCT,
                                @STANDARD       = @STANDARD,
                                @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                @TEMPLATE       = @TEMPLATE,
                                @LABEL_PRINT_QTY = @LABEL_PRINT_QTY;

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkRequest
IF OBJECT_ID ('dbo.ins_WorkRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequest;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkRequest
	Процедура вставки Work Request.

	Parameters:

		WorkType		- Режим,
		EquipmentID     - ID весов,
		ProfileID       - ID профиля,
		COMM_ORDER      - Номер коммерческого заказа,
		LENGTH          - Длина,
		BAR_WEIGHT      - Вес прутка,
		BAR_QUANTITY    - Количество прутков,
		MAX_WEIGHT      - Максимальный вес,
		MIN_WEIGHT      - Минимальный вес,
		SAMPLE_WEIGHT   - Вес образца,
		SAMPLE_LENGTH   - Длина образца,
		DEVIATION       - Отклонение,
		SANDWICH_MODE   - Признак "Бутерброд",
		AUTO_MANU_VALUE - Признак "Автоматический режим",
		NEMERA          - Признак "Немера",
		FACTORY_NUMBER  - Номер бирки,
		PACKS_LEFT      - Количество оставшихся пачек для режима "Разделение пачки",
		BINDING_DIA     - Диаметр увязки,
		BINDING_QTY     - Количество увязок,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки,
		WorkRequestID   - Work Request ID OUTPUT.

*/
CREATE PROCEDURE [dbo].[ins_WorkRequest]
@WorkType         NVARCHAR(50),
@EquipmentID      INT,
@ProfileID        INT          = NULL,
@COMM_ORDER       NVARCHAR(50) = NULL,
@LENGTH           NVARCHAR(50) = NULL,
@BAR_WEIGHT       NVARCHAR(50) = NULL,
@BAR_QUANTITY     NVARCHAR(50) = NULL,
@MAX_WEIGHT       NVARCHAR(50) = NULL,
@MIN_WEIGHT       NVARCHAR(50) = NULL,
@SAMPLE_WEIGHT    NVARCHAR(50) = NULL,
@SAMPLE_LENGTH    NVARCHAR(50) = NULL,
@DEVIATION        NVARCHAR(50) = NULL,
@SANDWICH_MODE    NVARCHAR(50) = NULL,
@AUTO_MANU_VALUE  NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL,
@FACTORY_NUMBER   NVARCHAR(50) = NULL,
@PACKS_LEFT       NVARCHAR(50) = NULL,
@BINDING_DIA      NVARCHAR(50) = NULL,
@BINDING_QTY      NVARCHAR(50) = NULL,
@LABEL_PRINT_QTY INT           = NULL,
@WorkRequestID    INT OUTPUT
AS
BEGIN

   IF @WorkType IN (N'Standard')
      BEGIN
         SELECT @WorkRequestID=jo.[WorkRequest]
         FROM [dbo].[v_Parameter_Order] po
              INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=po.[JobOrder])
         WHERE po.[Value]=@COMM_ORDER
           AND po.[EquipmentID]=@EquipmentID;
      END;

   IF @WorkRequestID IS NULL
      BEGIN
         SET @WorkRequestID=NEXT VALUE FOR [dbo].[gen_WorkRequest];

         INSERT INTO [dbo].[WorkRequest] ([ID],[StartTime],[WorkType])
         VALUES (@WorkRequestID,CURRENT_TIMESTAMP,@WorkType);
      END;

   DECLARE @JobOrderID INT;
   EXEC [dbo].[ins_JobOrder] @WorkType        = @WorkType,
                             @WorkRequestID   = @WorkRequestID,
                             @EquipmentID     = @EquipmentID,
                             @ProfileID       = @ProfileID,
                             @COMM_ORDER      = @COMM_ORDER,
                             @LENGTH          = @LENGTH,
                             @BAR_WEIGHT      = @BAR_WEIGHT,
                             @BAR_QUANTITY    = @BAR_QUANTITY,
                             @MAX_WEIGHT      = @MAX_WEIGHT,
                             @MIN_WEIGHT      = @MIN_WEIGHT,
                             @SAMPLE_WEIGHT   = @SAMPLE_WEIGHT,
                             @SAMPLE_LENGTH   = @SAMPLE_LENGTH,
                             @DEVIATION       = @DEVIATION,
                             @SANDWICH_MODE   = @SANDWICH_MODE,
                             @AUTO_MANU_VALUE = @AUTO_MANU_VALUE,
                             @NEMERA          = @NEMERA,
                             @FACTORY_NUMBER  = @FACTORY_NUMBER,
                             @PACKS_LEFT      = @PACKS_LEFT,
                             @BINDING_DIA     = @BINDING_DIA,
                             @BINDING_QTY     = @BINDING_QTY,
							 @LABEL_PRINT_QTY = @LABEL_PRINT_QTY,
                             @JobOrderID      = @JobOrderID OUTPUT;

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkRequestStandart
IF OBJECT_ID ('dbo.ins_WorkRequestStandart',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequestStandart;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkRequestStandart
	Процедура вставки  стандартного Work Request.

	Parameters:

		EquipmentID     - ID весов,
		ProfileID       - ID профиля,
		COMM_ORDER      - Номер коммерческого заказа,
		LENGTH          - Длина,
		BAR_WEIGHT      - Вес прутка,
		BAR_QUANTITY    - Количество прутков,
		MAX_WEIGHT      - Максимальный вес,
		MIN_WEIGHT      - Минимальный вес,
		SAMPLE_WEIGHT   - Вес образца,
		SAMPLE_LENGTH   - Длина образца,
		DEVIATION       - Отклонение,
		SANDWICH_MODE   - Признак "Бутерброд",
		AUTO_MANU_VALUE - Признак "Автоматический режим",
		NEMERA          - Признак "Немера",
		FACTORY_NUMBER  - Номер бирки,
		PACKS_LEFT      - Количество оставшихся пачек для режима "Разделение пачки",
		BINDING_DIA     - Диаметр увязки,
		BINDING_QTY     - Количество увязок,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.

*/
CREATE PROCEDURE [dbo].[ins_WorkRequestStandart]
@EquipmentID      INT,
@ProfileID        INT,
@COMM_ORDER       NVARCHAR(50),
@LENGTH           NVARCHAR(50),
@BAR_WEIGHT       NVARCHAR(50),
@BAR_QUANTITY     NVARCHAR(50),
@MAX_WEIGHT       NVARCHAR(50),
@MIN_WEIGHT       NVARCHAR(50),
@SAMPLE_WEIGHT    NVARCHAR(50),
@SAMPLE_LENGTH    NVARCHAR(50),
@DEVIATION        NVARCHAR(50),
@SANDWICH_MODE    NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50),
@NEMERA           NVARCHAR(50),
@BINDING_DIA      NVARCHAR(50),
@BINDING_QTY      NVARCHAR(50),
@LABEL_PRINT_QTY  INT
AS
BEGIN

   DECLARE @WorkRequestID INT;

   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Standard',
                                @EquipmentID     = @EquipmentID,
                                @ProfileID       = @ProfileID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @LENGTH          = @LENGTH,
                                @BAR_WEIGHT      = @BAR_WEIGHT,
                                @BAR_QUANTITY    = @BAR_QUANTITY,
                                @MAX_WEIGHT      = @MAX_WEIGHT,
                                @MIN_WEIGHT      = @MIN_WEIGHT,
                                @SAMPLE_WEIGHT   = @SAMPLE_WEIGHT,
                                @SAMPLE_LENGTH   = @SAMPLE_LENGTH,
                                @DEVIATION       = @DEVIATION,
                                @SANDWICH_MODE   = @SANDWICH_MODE,
                                @AUTO_MANU_VALUE = @AUTO_MANU_VALUE,
                                @NEMERA          = @NEMERA,
                                @BINDING_DIA     = @BINDING_DIA,
                                @BINDING_QTY     = @BINDING_QTY,
								@LABEL_PRINT_QTY = @LABEL_PRINT_QTY,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandMaxWeight] @WorkRequestID = @WorkRequestID,
                                                @EquipmentID   = @EquipmentID,
                                                @TagValue      = @MAX_WEIGHT;

   EXEC [dbo].[ins_JobOrderOPCCommandMinWeight] @WorkRequestID = @WorkRequestID,
                                                @EquipmentID   = @EquipmentID,
                                                @TagValue      = @MIN_WEIGHT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = @SANDWICH_MODE;

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = @AUTO_MANU_VALUE;

END;
GO


--------------------------------------------------------------
-- Процедура dbo.set_RejectMode
IF OBJECT_ID ('dbo.set_RejectMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_RejectMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_RejectMode
	Процедура установки режима отбраковки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки
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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[set_RejectMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN

   EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Reject',
                                   @EquipmentID    = @EquipmentID,
                                   @COMM_ORDER     = @COMM_ORDER,
                                   @PROD_ORDER     = @PROD_ORDER,
                                   @CONTRACT_NO    = @CONTRACT_NO,
                                   @DIRECTION      = @DIRECTION,
                                   @SIZE           = @SIZE,
                                   @LENGTH         = @LENGTH,
                                   @TOLERANCE      = @TOLERANCE,
                                   @CLASS          = @CLASS,
                                   @STEEL_CLASS    = @STEEL_CLASS,
                                   @MELT_NO        = @MELT_NO,
                                   @PART_NO        = @PART_NO,
                                   @MIN_ROD        = @MIN_ROD,
                                   @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                   @BRIGADE_NO     = @BRIGADE_NO,
                                   @PROD_DATE      = @PROD_DATE,
                                   @UTVK           = @UTVK,
                                   @CHANGE_NO      = @CHANGE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @BUNT_NO        = @BUNT_NO,
                                   @PRODUCT        = @PRODUCT,
                                   @STANDARD       = @STANDARD,
                                   @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                   @TEMPLATE       = @TEMPLATE,
								   @LABEL_PRINT_QTY= @LABEL_PRINT_QTY;

   DECLARE @WorkRequestID INT;
   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Reject',
                                @EquipmentID     = @EquipmentID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @FACTORY_NUMBER  = @FACTORY_NUMBER,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_SeparateMode
IF OBJECT_ID ('dbo.set_SeparateMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_SeparateMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_SeparateMode
	Процедура установки режима разделения пачки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки
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
		PACKS_LEFT	   - Количество пачек,
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[set_SeparateMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@PACKS_LEFT     NVARCHAR(50)  = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN

   EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Separate',
                                   @EquipmentID    = @EquipmentID,
                                   @COMM_ORDER     = @COMM_ORDER,
                                   @PROD_ORDER     = @PROD_ORDER,
                                   @CONTRACT_NO    = @CONTRACT_NO,
                                   @DIRECTION      = @DIRECTION,
                                   @SIZE           = @SIZE,
                                   @LENGTH         = @LENGTH,
                                   @TOLERANCE      = @TOLERANCE,
                                   @CLASS          = @CLASS,
                                   @STEEL_CLASS    = @STEEL_CLASS,
                                   @MELT_NO        = @MELT_NO,
                                   @PART_NO        = @PART_NO,
                                   @MIN_ROD        = @MIN_ROD,
                                   @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                   @BRIGADE_NO     = @BRIGADE_NO,
                                   @PROD_DATE      = @PROD_DATE,
                                   @UTVK           = @UTVK,
                                   @CHANGE_NO      = @CHANGE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @BUNT_NO        = @BUNT_NO,
                                   @PRODUCT        = @PRODUCT,
                                   @STANDARD       = @STANDARD,
                                   @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                   @TEMPLATE       = @TEMPLATE,
								   @LABEL_PRINT_QTY= @LABEL_PRINT_QTY;

   DECLARE @WorkRequestID INT;
   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Separate',
                                @EquipmentID     = @EquipmentID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @FACTORY_NUMBER  = @FACTORY_NUMBER,
                                @PACKS_LEFT      = @PACKS_LEFT,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_SortMode
IF OBJECT_ID ('dbo.set_SortMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_SortMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_SortMode
	Процедура установки режима сортировки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки
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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[set_SortMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN

   EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Sort',
                                   @EquipmentID    = @EquipmentID,
                                   @COMM_ORDER     = @COMM_ORDER,
                                   @PROD_ORDER     = @PROD_ORDER,
                                   @CONTRACT_NO    = @CONTRACT_NO,
                                   @DIRECTION      = @DIRECTION,
                                   @SIZE           = @SIZE,
                                   @LENGTH         = @LENGTH,
                                   @TOLERANCE      = @TOLERANCE,
                                   @CLASS          = @CLASS,
                                   @STEEL_CLASS    = @STEEL_CLASS,
                                   @MELT_NO        = @MELT_NO,
                                   @PART_NO        = @PART_NO,
                                   @MIN_ROD        = @MIN_ROD,
                                   @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                   @BRIGADE_NO     = @BRIGADE_NO,
                                   @PROD_DATE      = @PROD_DATE,
                                   @UTVK           = @UTVK,
                                   @CHANGE_NO      = @CHANGE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @BUNT_NO        = @BUNT_NO,
                                   @PRODUCT        = @PRODUCT,
                                   @STANDARD       = @STANDARD,
                                   @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                   @TEMPLATE       = @TEMPLATE,
								   @LABEL_PRINT_QTY= @LABEL_PRINT_QTY;

   DECLARE @WorkRequestID INT;
   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Sort',
                                @EquipmentID     = @EquipmentID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @FACTORY_NUMBER  = @FACTORY_NUMBER,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO

--------------------------------------------------------------
-- Процедура upd_Order
IF OBJECT_ID ('dbo.upd_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_Order;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_Order
	Процедура изменения заказа.

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
		TEMPLATE       - Шаблон бирки
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/

CREATE PROCEDURE [dbo].[upd_Order] 
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250) = NULL,
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN
   DECLARE @OpSegmentRequirementID INT,
           @err_message            NVARCHAR(255);

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   SELECT @OpSegmentRequirementID=spo.OpSegmentRequirement
   FROM [dbo].[v_SegmentParameter_Order] spo
   WHERE spo.Value=@COMM_ORDER;

   IF @OpSegmentRequirementID IS NULL
      BEGIN
         SET @err_message = N'Коммерческий заказ [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] не найден';
         THROW 60010, @err_message, 1;
      END;

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
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'LABEL_PRINT_QTY',CAST(@LABEL_PRINT_QTY AS NVARCHAR(50)) WHERE @LABEL_PRINT_QTY IS NOT NULL;

   DELETE FROM [dbo].[SegmentParameter]
   WHERE [OpSegmentRequirement]=@OpSegmentRequirementID;

   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
   SELECT t.value,@OpSegmentRequirementID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);
   
   /*
   MERGE [dbo].[SegmentParameter] sp
   USING (SELECT t.value,pt.ID
          FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
   ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
   WHEN MATCHED THEN
      UPDATE SET sp.[Value]=tt.value
   WHEN NOT MATCHED THEN
      INSERT ([Value],[OpSegmentRequirement],[PropertyType])
      VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
   */

END;
GO

--------------------------------------------------------------
-- Процедура upd_WorkDefinition
IF OBJECT_ID ('dbo.upd_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_WorkDefinition
	Процедура изменения WorkDefinition.

	Parameters:

		EquipmentID    - ID весов,
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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[upd_WorkDefinition]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT           = NULL,
@LABEL_PRINT_QTY INT          = NULL
AS
BEGIN
   DECLARE @WorkDefinitionID     INT,
           @err_message          NVARCHAR(255);

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
   ELSE IF @PROD_ORDER IS NULL
    THROW 60001, N'Параметр "Производственный заказ" обязательный', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CLASS IS NULL
    THROW 60001, N'CLASS param required', 1;
   ELSE IF @STEEL_CLASS IS NULL
    THROW 60001, N'STEEL_CLASS param required', 1;
   ELSE IF @MELT_NO IS NULL
    THROW 60001, N'MELT_NO param required', 1;
   ELSE IF @PART_NO IS NULL
    THROW 60001, N'PART_NO param required', 1;
   ELSE IF @BRIGADE_NO IS NULL
    THROW 60001, N'BRIGADE_NO param required', 1;
   ELSE IF @PROD_DATE IS NULL
    THROW 60001, N'PROD_DATE param required', 1;
   ELSE IF @UTVK IS NULL
    THROW 60001, N'UTVK param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   SELECT @WorkDefinitionID=pso.WorkDefinitionID
   FROM [dbo].[v_ParameterSpecification_Order] pso
   WHERE pso.[Value]=@COMM_ORDER
     AND pso.[EquipmentID]=@EquipmentID;

   IF @WorkDefinitionID IS NULL
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@WorkDefinitionID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N'WORK_DEFINITION_ID',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

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
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'LABEL_PRINT_QTY',CAST(@LABEL_PRINT_QTY AS NVARCHAR(50)) WHERE @LABEL_PRINT_QTY IS NOT NULL;

   DELETE FROM [dbo].[ParameterSpecification]
   WHERE [WorkDefinitionID]=@WorkDefinitionID;

   INSERT INTO [dbo].[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
   SELECT t.value,@WorkDefinitionID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);
   
   /*
   MERGE [dbo].[SegmentParameter] sp
   USING (SELECT t.value,pt.ID
          FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
   ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
   WHEN MATCHED THEN
      UPDATE SET sp.[Value]=tt.value
   WHEN NOT MATCHED THEN
      INSERT ([Value],[OpSegmentRequirement],[PropertyType])
      VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
   */

END;
GO

