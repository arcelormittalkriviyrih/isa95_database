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

