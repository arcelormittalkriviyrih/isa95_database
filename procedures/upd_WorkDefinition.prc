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
