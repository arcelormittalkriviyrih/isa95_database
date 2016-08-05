--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandMaxWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandMaxWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandMaxWeight;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandMaxWeight
	Процедура отправки максимального веса на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
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
