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
