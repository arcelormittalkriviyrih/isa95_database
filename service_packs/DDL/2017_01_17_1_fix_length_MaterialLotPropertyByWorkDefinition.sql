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
                            Value NVARCHAR(250));

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
		BINDING_QTY     - Количество увязок.
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
   SELECT N'BINDING_QTY',@BINDING_QTY WHERE @BINDING_QTY IS NOT NULL;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT t.value,@JobOrderID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

