--------------------------------------------------------------
-- Процедура ins_CreateOrder
IF OBJECT_ID ('dbo.ins_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_Order;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_Order] 
@COMM_ORDER		NVARCHAR(50),
@CONTRACT_NO	NVARCHAR(50),
@DIRECTION      NVARCHAR(50),
@TEMPLATE		INT,
@LENGTH			NVARCHAR(50),
@PROFILE		INT,
@ADDRESS		NVARCHAR(50) = NULL,
@BUNT_DIA		NVARCHAR(50) = NULL,
@CLASS			NVARCHAR(50) = NULL,
@MIN_ROD		NVARCHAR(50) = NULL,
@STEEL_CLASS	NVARCHAR(50) = NULL,
@PRODUCT		NVARCHAR(50) = NULL,
@STANDARD		NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL
AS
BEGIN
   DECLARE @OperationsRequestID     INT,
           @OpSegmentRequirementID  INT,
           @OpMaterialRequirementID INT,
           @err_message             NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @COMM_ORDER IS NULL
    THROW 60001, N'COMM_ORDER param required', 1;
   ELSE IF EXISTS (SELECT NULL FROM [dbo].[v_SegmentParameter_Order] WHERE [Value]=@COMM_ORDER)
      BEGIN
         SET @err_message = N'Заказ [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] уже существует';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @PROFILE IS NULL
    THROW 60001, N'PROFILE param required', 1;
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'TEMPLATE param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialDefinition] WHERE [ID]=@PROFILE)
      THROW 60010, N'Указанный профиль не существует в таблице MaterialDefinition', 1;
   ELSE 
	BEGIN

	   SET @OperationsRequestID=NEXT VALUE FOR [dbo].[gen_OperationsRequest];
	   INSERT INTO [dbo].[OperationsRequest] ([ID]) VALUES (@OperationsRequestID);

	   SET @OpSegmentRequirementID=NEXT VALUE FOR [dbo].[gen_OpSegmentRequirement];
	   INSERT INTO [dbo].[OpSegmentRequirement] ([ID],[OperationsRequest]) VALUES (@OpSegmentRequirementID,@OperationsRequestID);

	   --SET @OpMaterialRequirementID=NEXT VALUE FOR [dbo].[gen_MaterialRequirement];
	   INSERT INTO [dbo].[OpMaterialRequirement] ([MaterialClassID],[MaterialDefinitionID],[SegmenRequirementID])
	   SELECT md.[MaterialClassID],md.[ID],@OpSegmentRequirementID
	   FROM [dbo].[MaterialDefinition] md 
	   WHERE md.[ID]=@PROFILE;

	   INSERT @tblParams
	   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
	   UNION ALL
	   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
	   UNION ALL
	   SELECT N'MIN_ROD',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
	   UNION ALL
	   SELECT N'CONTRACT_NO',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
	   UNION ALL
	   SELECT N'DIRECTION',@DIRECTION WHERE @DIRECTION IS NOT NULL
	   UNION ALL
	   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
	   UNION ALL
	   SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
	   UNION ALL
	   SELECT N'STEEL_CLASS',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
	   UNION ALL
	   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
	   UNION ALL
	   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
	   UNION ALL
	   SELECT N'ADDRESS',@ADDRESS WHERE @ADDRESS IS NOT NULL
	   UNION ALL
	   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
	   UNION ALL
	   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

	   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
	   SELECT t.value,@OpSegmentRequirementID,pt.ID
	   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   END;

END;
GO

--------------------------------------------------------------
-- Процедура upd_CreateOrder
IF OBJECT_ID ('dbo.upd_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_Order;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_Order] 
@COMM_ORDER		NVARCHAR(50),
@CONTRACT_NO	NVARCHAR(50),
@DIRECTION      NVARCHAR(50),
@TEMPLATE		INT,
@LENGTH			NVARCHAR(50),
@PROFILE		INT,
@ADDRESS		NVARCHAR(50) = NULL,
@BUNT_DIA		NVARCHAR(50) = NULL,
@CLASS			NVARCHAR(50) = NULL,
@MIN_ROD		NVARCHAR(50) = NULL,
@STEEL_CLASS	NVARCHAR(50) = NULL,
@PRODUCT		NVARCHAR(50) = NULL,
@STANDARD		NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL
AS
BEGIN
   DECLARE @OpSegmentRequirementID INT,
           @err_message            NVARCHAR(255);

   IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @COMM_ORDER IS NULL
    THROW 60001, N'COMM_ORDER param required', 1;
   ELSE IF @PROFILE IS NULL
    THROW 60001, N'PROFILE param required', 1;
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'TEMPLATE param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialDefinition] WHERE [ID]=@PROFILE)
      THROW 60010, N'Указанный профиль не существует в таблице MaterialDefinition', 1;
   ELSE
      BEGIN
         DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                                  Value NVARCHAR(50));

         SELECT @OpSegmentRequirementID=sreq.ID
         FROM [dbo].[OpSegmentRequirement] sreq
              INNER JOIN [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
              INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER' AND sp.Value=@COMM_ORDER);

         IF @OpSegmentRequirementID IS NULL
            BEGIN
               SET @err_message = N'Order [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
               THROW 60010, @err_message, 1;
            END;

         UPDATE [dbo].[OpMaterialRequirement]
         SET [MaterialClassID] = md.[MaterialClassID],
             [MaterialDefinitionID] = md.[ID]
         FROM (SELECT [MaterialClassID],[ID]
               FROM [dbo].[MaterialDefinition]
               WHERE [ID]=@PROFILE) md
         WHERE [SegmenRequirementID]=@OpSegmentRequirementID;

         INSERT @tblParams
			SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
			UNION ALL
			SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
			UNION ALL
			SELECT N'MIN_ROD',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
			UNION ALL
			SELECT N'CONTRACT_NO',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
			UNION ALL
			SELECT N'DIRECTION',@DIRECTION WHERE @DIRECTION IS NOT NULL
			UNION ALL
			SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
			UNION ALL
			SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
			UNION ALL
			SELECT N'STEEL_CLASS',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
			UNION ALL
			SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
			UNION ALL
			SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
			UNION ALL
			SELECT N'ADDRESS',@ADDRESS WHERE @ADDRESS IS NOT NULL
			UNION ALL		   
		SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

         MERGE [dbo].[SegmentParameter] sp
         USING (SELECT t.value,pt.ID
                FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
         ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
         WHEN MATCHED THEN
            UPDATE SET sp.[Value]=tt.value
         WHEN NOT MATCHED THEN
            INSERT ([Value],[OpSegmentRequirement],[PropertyType])
            VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
      END;
END;
GO

--------------------------------------------------------------
-- Процедура del_CreateOrder
IF OBJECT_ID ('dbo.del_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_Order;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_Order]
@COMM_ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @OperationsRequestID    INT,
           @OpSegmentRequirementID INT,
           @err_message            NVARCHAR(255);

   IF @COMM_ORDER IS NULL
      THROW 60001, N'COMM_ORDER param required', 1;

   SELECT @OpSegmentRequirementID=sreq.ID,
          @OperationsRequestID=sreq.OperationsRequest
   FROM [dbo].[OpSegmentRequirement] sreq
        INNER JOIN  [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER' AND sp.Value=@COMM_ORDER);

   IF @OpSegmentRequirementID IS NULL
      BEGIN
         SET @err_message = N'Order [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DELETE FROM [dbo].[SegmentParameter]
   WHERE OpSegmentRequirement=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OpMaterialRequirement]
   WHERE [SegmenRequirementID]=@OpSegmentRequirementID;

   DELETE [dbo].[OpSegmentRequirement]
   WHERE ID=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OperationsRequest]
   WHERE ID=@OperationsRequestID;

END;
GO

--------------------------------------------------------------
-- Процедура по номеру контролера на ходит ProductionRequest (в состоянии RequestState=InProgress) 
-- и для него создает запись в следующем наборе таблиц: ProductionResponce, SegmentResponce, MaterialActual, MaterialLot
IF OBJECT_ID ('dbo.ins_MaterialLotByController',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByController;
GO

CREATE PROCEDURE dbo.ins_MaterialLotByController
   @ControllerID   INT
AS
BEGIN
  DECLARE
    @ProductionRequestID  INT,
    @SegmentResponseID    INT,
    @ProductionResponseID INT,
    @MaterialLotID        INT,
    @MaterialActualID     INT,
    @Quantity             INT,
    @now                  DATETIMEOFFSET = CURRENT_TIMESTAMP,
    @err_message          NVARCHAR(255);

  SELECT @ProductionRequestID=sreq.ProductionRequest,
         @Quantity=kl.WEIGHT_CURRENT_VALUE
  FROM dbo.v_kep_logger kl
       INNER JOIN dbo.EquipmentRequirement ereq ON (ereq.EquipmentID=kl.EquipmentID)
       INNER JOIN dbo.SegmentRequirement sreq ON (sreq.ID=ereq.SegmentRequirementID)
       INNER JOIN dbo.ProductionRequest preq ON (preq.ID=sreq.ProductionRequest AND preq.RequestState=N'InProgress')
  WHERE kl.Controller_ID=@ControllerID;

  IF @ProductionRequestID IS NULL
    BEGIN
      SET @err_message = N'Для контроллера №' + CAST(@ControllerID AS NVARCHAR) + ' не найден ProductionRequest в состоянии "InProgress"';
      THROW 60010, @err_message, 1;
    END;

  EXEC dbo.ins_ProductionResponse @ProductionRequestID  = @ProductionRequestID,
                                  @StartTime            = @now,
                                  @EndTime              = @now,
                                  @ResponseState        = N'ToPrint',
                                  @ProductionResponseID = @ProductionResponseID OUTPUT;

  EXEC dbo.ins_SegmentResponse @Description        = NULL,
                               @ActualStartTime    = @now,
                               @ActualEndTime      = @now,
                               @SegmentState       = NULL,
                               @ProductionRequest  = @ProductionRequestID,
                               @ProductionResponse = @ProductionResponseID,
                               @SegmentResponseID  = @SegmentResponseID OUTPUT;

  EXEC dbo.ins_MaterialLot @Description          = NULL,
                           @Status               = NULL,
                           @Quantity             = @Quantity,
                           @MaterialLotID        = @MaterialLotID OUTPUT;

  EXEC dbo.ins_MaterialActual @MaterialLotID     = @MaterialLotID,
                              @Description       = NULL,
                              @Quantity          = NULL,
                              @SegmentResponseID = @SegmentResponseID,
                              @MaterialActualID  = @MaterialActualID OUTPUT
END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabel
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabel;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabel]
@PrinterID      INT = NULL,
@MaterialLotID  INT,
@Command        NVARCHAR(50),
@CommandRule    NVARCHAR(50) = NULL

AS
BEGIN

   DECLARE @JobOrderID  INT,
           @err_message NVARCHAR(255);

   IF @Command IS NULL
      THROW 60001, N'Command param required', 1;
   ELSE IF @PrinterID IS NULL AND @Command=N'Print' 
      THROW 60001, N'PrinterID param required for Print Command', 1;   
   ELSE IF @MaterialLotID IS NULL
      THROW 60001, N'MaterialLotID param required', 1;   
   ELSE IF @CommandRule IS NULL AND @Command=N'Email' 
      THROW 60001, N'CommandRule param required for Email Command', 1;   
   ELSE IF @PrinterID IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Equipment] WHERE [ID]=@PrinterID)
      BEGIN
         SET @err_message = N'Принтер с кодом [' + CAST(@PrinterID AS NVARCHAR) + N'] не существует';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLot] WHERE [ID]=@MaterialLotID)
      BEGIN
         SET @err_message = N'MaterialLot ID [' + CAST(@MaterialLotID AS NVARCHAR) + N'] does not exists';
         THROW 60010, @err_message, 1;
      END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [DispatchStatus], [Command], [CommandRule])
   VALUES (@JobOrderID,N'Print',N'ToPrint',@Command,@CommandRule);

   IF @PrinterID IS NOT NULL
	  BEGIN
		 INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID], [EquipmentID], [JobOrderID])
		 SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
		 FROM [dbo].[Equipment] eq
		 WHERE [ID]=@PrinterID;
	  END;

   INSERT INTO [dbo].[Parameter] ([Value], [JobOrder], [PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;
GO

