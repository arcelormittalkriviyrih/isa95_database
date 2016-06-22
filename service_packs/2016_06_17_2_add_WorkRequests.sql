--------------------------------------------------------------
-- Процедура ins_JobOrderInit
IF OBJECT_ID ('dbo.ins_JobOrderInit',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderInit;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderInit]
@WorkRequestID    INT,
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
@AUTO_MANU_VALUE  NVARCHAR(50)

AS
BEGIN

   DECLARE @JobOrderID  INT;

   UPDATE [dbo].[JobOrder]
   SET [WorkType]=N'INIT_LOG'
   WHERE [WorkRequest]=@WorkRequestID
     AND [WorkType]=N'INIT';

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest])
   VALUES (@JobOrderID,N'INIT',CURRENT_TIMESTAMP,@WorkRequestID);

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
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT t.value,@JobOrderID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура upd_JobOrderInit
IF OBJECT_ID ('dbo.upd_JobOrderInit',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderInit;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_JobOrderInit]
@WorkRequestID   INT,
@EquipmentID     INT,
@ProfileID       INT,
@COMM_ORDER      NVARCHAR(50),
@LENGTH          NVARCHAR(50),
@BAR_WEIGHT      NVARCHAR(50),
@BAR_QUANTITY    NVARCHAR(50),
@MAX_WEIGHT      NVARCHAR(50),
@MIN_WEIGHT      NVARCHAR(50),
@SAMPLE_WEIGHT   NVARCHAR(50),
@SAMPLE_LENGTH   NVARCHAR(50),
@DEVIATION       NVARCHAR(50),
@SANDWICH_MODE   NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50)


AS
BEGIN

   EXEC [dbo].[ins_JobOrderInit] @WorkRequestID   = @WorkRequestID,
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
                                 @AUTO_MANU_VALUE = @AUTO_MANU_VALUE;

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
@AUTO_MANU_VALUE  NVARCHAR(50)

AS
BEGIN

   DECLARE @WorkRequestID INT;

   SELECT @WorkRequestID=jo.[WorkRequest]
   FROM [dbo].[v_Parameter_Order] po
        INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=po.[JobOrder])
   WHERE po.[Value]=@COMM_ORDER
     AND po.[EquipmentID]=@EquipmentID;

   IF @WorkRequestID IS NULL
      BEGIN
         SET @WorkRequestID=NEXT VALUE FOR [dbo].[gen_WorkRequest];

         INSERT INTO [dbo].[WorkRequest] ([ID],[StartTime])
         VALUES (@WorkRequestID,CURRENT_TIMESTAMP);
      END;

   EXEC [dbo].[ins_JobOrderInit] @WorkRequestID   = @WorkRequestID,
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
                                 @AUTO_MANU_VALUE = @AUTO_MANU_VALUE;

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
