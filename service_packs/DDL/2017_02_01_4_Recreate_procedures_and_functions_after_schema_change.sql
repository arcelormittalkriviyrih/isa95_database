----------------------------------------------------------------
IF OBJECT_ID ('dbo.del_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_WorkDefinition;
GO

/*
	Procedure: del_WorkDefinition
	Процедура удаления WorkDefinition.
	
	Parameters:

      COMM_ORDER - Номер коммерческого заказа
*/
CREATE PROCEDURE [dbo].[del_WorkDefinition]
@COMM_ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @WorkDefinitionID   INT,
           @err_message        NVARCHAR(255);

   IF @COMM_ORDER IS NULL
      THROW 60001, N'COMM_ORDER param required', 1;

   SELECT @WorkDefinitionID=pso.WorkDefinitionID
   FROM [dbo].[v_ParameterSpecification_Order] pso
   WHERE pso.Value=@COMM_ORDER;

   IF @WorkDefinitionID IS NULL
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DELETE FROM [ISA95_OPERATION_DEFINITION].[ParameterSpecification]
   WHERE WorkDefinitionID=@WorkDefinitionID;

   DELETE FROM [dbo].[WorkDefinition]
   WHERE ID=@WorkDefinitionID;

END;
GO


----------------------------------------------------------------
IF OBJECT_ID ('dbo.ins_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinition;
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
   INSERT INTO ISA95_OPERATION_DEFINITION.[OperationsSegment] ([ID],[OperationsType]) VALUES (@OperationsSegmentID,N'Standard');

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

   INSERT INTO ISA95_OPERATION_DEFINITION.[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
   SELECT t.value,@WorkDefinitionID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO


----------------------------------------------------------------
IF OBJECT_ID ('dbo.upd_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_WorkDefinition;
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

   DELETE FROM ISA95_OPERATION_DEFINITION.[ParameterSpecification]
   WHERE [WorkDefinitionID]=@WorkDefinitionID;

   INSERT INTO ISA95_OPERATION_DEFINITION.[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
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
go


----------------------------------------------------------------
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByWorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByWorkDefinition;
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
                            Value NVARCHAR(250));

   SET @LEAVE_NO =
	   (
		  SELECT sp.[Value]
		  FROM [ISA95_OPERATION_DEFINITION].[ParameterSpecification] sp
			  INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = sp.[PropertyType])
		  WHERE(sp.WorkDefinitionID = @WorkDefinitionID)
			  AND pt.[Value] = N'COMM_ORDER'
	   );

   INSERT @tblParams
   SELECT pt.[Value],sp.[Value]
   FROM [ISA95_OPERATION_DEFINITION].[ParameterSpecification] sp
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
go


----------------------------------------------------------------
IF OBJECT_ID ('dbo.get_LatestWorkRequests',N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_LatestWorkRequests;
GO

CREATE FUNCTION dbo.get_LatestWorkRequests(@EquipmentID INT)
RETURNS @get_LatestWorkRequests TABLE (WorkRequestID INT,
                                       JobOrderID    INT,
                                       EquipmentID   INT,
                                       ProfileID     INT,
                                       WorkType      NVARCHAR(50),
                                       PropertyType  NVARCHAR(50),
                                       Value         NVARCHAR(250))
AS
BEGIN

   DECLARE @JobOrderID       INT,
           @WorkRequestID    INT,
           @WorkDefinitionID INT,
           @ProfileID        INT,
           @WorkType         NVARCHAR(50),
           @PacksLeft        NVARCHAR(50);

   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

   SELECT @WorkRequestID=jo.[WorkRequest],
          @WorkType=wr.[WorkType],
          @ProfileID=mr.[MaterialDefinitionID]
   FROM [dbo].[JobOrder] jo
        INNER JOIN [dbo].[WorkRequest] wr ON (jo.[WorkRequest]=wr.[ID])
        LEFT OUTER JOIN [dbo].[OpMaterialRequirement] mr ON (mr.[JobOrderID]=jo.[ID] AND mr.[MaterialClassID]=dbo.get_MaterialClassIDByCode(N'PROFILE'))
   WHERE jo.[ID]=@JobOrderID;

   INSERT @get_LatestWorkRequests
   SELECT @WorkRequestID WorkRequestID,
          par.[JobOrder] JobOrderID,
          er.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N'Standard') WorkType,
          pt.[Value] PropertyType,
          par.[Value]
   FROM [dbo].[Parameter] par
        INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=par.[JobOrder])
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=par.[PropertyType] AND pt.[Value] NOT IN (N'COMM_ORDER'))
   WHERE par.[JobOrder]=@JobOrderID
   UNION ALL
   SELECT @WorkRequestID,
          @JobOrderID,
          oes.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N'Standard') WorkType,
          pt.[Value] PropertyType,
          ps.[Value]
   FROM ISA95_OPERATION_DEFINITION.[ParameterSpecification] ps
        INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=ps.WorkDefinitionID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=ps.[PropertyType] AND pt.[Value] IN (N'COMM_ORDER',N'BRIGADE_NO',N'PROD_DATE'))
   WHERE ps.[WorkDefinitionID]=@WorkDefinitionID;

RETURN;

END;
Go


----------------------------------------------------------------
IF OBJECT_ID ('dbo.get_WorkDefinitionPropertiesAll',N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_WorkDefinitionPropertiesAll;
GO

CREATE FUNCTION dbo.get_WorkDefinitionPropertiesAll(@COMM_ORDER NVARCHAR(50))
RETURNS @retWorkDefinitionPropertiesAll TABLE (ID               INT,
                                               Description      NVARCHAR(50),
                                               Value            NVARCHAR(250),
                                               WorkDefinitionID INT,
                                               Property         NVARCHAR(50))
AS
BEGIN

   DECLARE @WorkDefinitionID     INT,
           @OpSegmentRequirement INT;

   SELECT @WorkDefinitionID=ps.[WorkDefinitionID]
   FROM ISA95_OPERATION_DEFINITION.[ParameterSpecification] ps
        INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=ps.[PropertyType] AND ptco.[Value]=N'COMM_ORDER')
   WHERE ps.[Value]=@COMM_ORDER;

  IF NOT @WorkDefinitionID IS NULL
     BEGIN 
        INSERT @retWorkDefinitionPropertiesAll
           SELECT ps.[ID],
                  pt.[Description],
                  ps.[Value],
                  ps.[WorkDefinitionID],
                  pt.[Value]
           FROM ISA95_OPERATION_DEFINITION.[ParameterSpecification] ps
                INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
           WHERE ps.[WorkDefinitionID]=@WorkDefinitionID
     END
  ELSE
     BEGIN
        SELECT @OpSegmentRequirement=sp.[OpSegmentRequirement]
        FROM [dbo].[SegmentParameter] sp
             INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=sp.[PropertyType] AND ptco.[Value]=N'COMM_ORDER')
        WHERE sp.[Value]=@COMM_ORDER;

        INSERT @retWorkDefinitionPropertiesAll
          SELECT sp.ID,
                 pt.Description,
                 sp.[Value],
                 NULL,
                 pt.[Value] Property
          FROM dbo.OpSegmentRequirement sr
               INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
               INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
          WHERE sr.[ID]=@OpSegmentRequirement;
     END

  RETURN;

END;

GO
