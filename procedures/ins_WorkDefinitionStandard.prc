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

