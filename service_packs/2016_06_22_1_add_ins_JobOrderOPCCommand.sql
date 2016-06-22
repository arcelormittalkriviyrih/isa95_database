--------------------------------------------------------------
-- Процедура ins_WorkRequest
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommand',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommand;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommand]
@WorkRequestID   INT,
@EquipmentID     INT,
@Tag             NVARCHAR(255),
@TagType         NVARCHAR(50),
@TagValue        NVARCHAR(255)
AS
BEGIN

   DECLARE @err_message   NVARCHAR(255);

   IF @WorkRequestID IS NULL
    THROW 60001, N'WorkRequestID param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[WorkRequest] WHERE [ID]=@WorkRequestID)
      BEGIN
         SET @err_message = N'WorkRequest [' + CAST(@WorkRequestID AS NVARCHAR) + N'] not exists';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @EquipmentID IS NULL
    THROW 60001, N'EquipmentID param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Equipment] WHERE [ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment [' + CAST(@EquipmentID AS NVARCHAR) + N'] not exists';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @Tag IS NULL
    THROW 60001, N'Tag param required', 1;
   ELSE IF @TagType IS NULL
    THROW 60001, N'TagType param required', 1;
   ELSE IF @TagType NOT IN (N'Boolean',N'Byte',N'Short',N'Word',N'Long',N'Dword',N'Float',N'Double',N'Char',N'String')
      BEGIN
         SET @err_message = N'[' + @TagType + N'] is not valid value for TagType param';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @TagValue IS NULL
    THROW 60001, N'TagValue param required', 1;

   DECLARE @JobOrderID  INT,
           @Command     NVARCHAR(50),
           @CommandRule NVARCHAR(50);

   SET @JobOrderID = NEXT VALUE FOR [dbo].[gen_JobOrder];
   SET @Command = dbo.get_EquipmentPropertyValue(@EquipmentID,N'OPC_DEVICE_NAME')+ N'.' +  @Tag;
   SET @CommandRule = N'(' + @TagType + N')' + @TagValue;
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest], [DispatchStatus], [Command], [CommandRule])
   VALUES (@JobOrderID,N'KEPCommands',CURRENT_TIMESTAMP,@WorkRequestID,N'ToSend',@Command,@CommandRule);

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeight;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeWeight]
@WorkRequestID   INT,
@EquipmentID     INT
AS
BEGIN

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_WEIGHT',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTara
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTara',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTara;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeTara]
@WorkRequestID   INT,
@EquipmentID     INT
AS
BEGIN

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_TARA',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandSandwich
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandSandwich',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandSandwich;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandSandwich]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF @TagValue NOT IN (N'true',N'false')
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_SANDWICH',
                                    @TagType       = N'Boolean',
                                    @TagValue      = @TagValue;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandAutoManu
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandAutoManu',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandAutoManu;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandAutoManu]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF @TagValue NOT IN (N'true',N'false')
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'AUTO_MANU',
                                    @TagType       = N'Boolean',
                                    @TagValue      = @TagValue;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandMinWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandMinWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandMinWeight;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandMinWeight]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF ISNUMERIC(@TagValue)=0
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'WEIGHT_SP_MIN',
                                    @TagType       = N'Float',
                                    @TagValue      = @TagValue;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandMaxWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandMaxWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandMaxWeight;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandMaxWeight]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF ISNUMERIC(@TagValue)=0
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;


EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'WEIGHT_SP_MAX',
                                    @TagType       = N'Float',
                                    @TagValue      = @TagValue;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTaraByCommOrder
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTaraByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTaraByCommOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeTaraByCommOrder]
@COMM_ORDER    NVARCHAR(50),
@EquipmentID   INT
AS
BEGIN

   DECLARE @WorkRequestID INT;

   SELECT @WorkRequestID=jo.[WorkRequest]
   FROM [dbo].[v_Parameter_Order] po
        INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=po.[JobOrder])
   WHERE po.[Value]=@COMM_ORDER
     AND po.[EquipmentID]=@EquipmentID;

   EXEC [dbo].[ins_JobOrderOPCCommandTakeTara] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeightByCommOrder
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeightByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeightByCommOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeWeightByCommOrder]
@COMM_ORDER    NVARCHAR(50),
@EquipmentID   INT
AS
BEGIN


   DECLARE @WorkRequestID INT;

   SELECT @WorkRequestID=jo.[WorkRequest]
   FROM [dbo].[v_Parameter_Order] po
        INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=po.[JobOrder])
   WHERE po.[Value]=@COMM_ORDER
     AND po.[EquipmentID]=@EquipmentID;

   EXEC [dbo].[ins_JobOrderOPCCommandTakeWeight] @WorkRequestID = @WorkRequestID,
                                                 @EquipmentID   = @EquipmentID;

END;
GO
