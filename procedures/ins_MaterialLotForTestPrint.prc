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
		TEMPLATE       - Шаблон бирки,
		LABEL_PRINT_QTY - Количество печатаемых копий бирки.
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotForTestPrint]
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
