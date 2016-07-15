--------------------------------------------------------------
-- Процедура ins_JobOrder
IF OBJECT_ID ('dbo.ins_JobOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrder]
@WorkType         NVARCHAR(50),
@WorkRequestID    INT,
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
                            Value NVARCHAR(50));

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

--------------------------------------------------------------
-- Процедура ins_WorkRequest
IF OBJECT_ID ('dbo.ins_WorkRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequest;
GO

SET QUOTED_IDENTIFIER ON
GO

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
@BINDING_QTY      NVARCHAR(50)
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
