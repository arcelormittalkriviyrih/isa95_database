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
