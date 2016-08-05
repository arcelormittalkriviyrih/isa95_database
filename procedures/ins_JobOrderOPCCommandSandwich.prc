--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandSandwich
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandSandwich',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandSandwich;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandSandwich
	Процедура отправки Sandwich на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
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
